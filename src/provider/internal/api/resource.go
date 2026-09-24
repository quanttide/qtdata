package api

import (
	"encoding/json"
	"log/slog"
	"net/http"
	"time"

	"github.com/quanttide/qtdata-provider/internal/store"
)

// Resource 是可持久化资源的最小契约：ID 的读与写。
type Resource interface {
	GetID() string
	SetID(id string)
}

// resource 承载一个集合的五个标准动作（list/get/create/update/delete），
// 项目、任务、数据集三个领域资源复用同一套 HTTP 语义。
type resource[T Resource] struct {
	store      store.Store
	collection string
	newItem    func() T       // 返回非空的新资源实例，供解码与回写
	validate   func(T) string // 返回空串即校验通过；可为 nil
	onCreate   func(T)        // 可为 nil；写入前填充创建时字段
	onUpdate   func(T)        // 可为 nil；写入前填充更新时字段
}

func nowRFC3339() string {
	return time.Now().UTC().Format(time.RFC3339)
}

func (h *resource[T]) list(w http.ResponseWriter, r *http.Request) {
	data, err := h.store.List(h.collection)
	if err != nil {
		slog.Error("list "+h.collection, "error", err)
		WriteError(w, "INTERNAL_ERROR", "failed to list "+h.collection, http.StatusInternalServerError)
		return
	}
	var items []T
	if err := json.Unmarshal(data, &items); err != nil {
		slog.Error("parse "+h.collection, "error", err)
		WriteError(w, "INTERNAL_ERROR", "failed to parse "+h.collection, http.StatusInternalServerError)
		return
	}
	WriteJSON(w, items, http.StatusOK)
}

func (h *resource[T]) get(w http.ResponseWriter, r *http.Request) {
	id := r.PathValue("id")
	data, err := h.store.Get(h.collection, id)
	if err != nil {
		WriteError(w, "NOT_FOUND", h.collection+" not found", http.StatusNotFound)
		return
	}
	item := h.newItem()
	if err := json.Unmarshal(data, item); err != nil {
		slog.Error("parse "+h.collection, "error", err)
		WriteError(w, "INTERNAL_ERROR", "failed to parse "+h.collection, http.StatusInternalServerError)
		return
	}
	WriteJSON(w, item, http.StatusOK)
}

func (h *resource[T]) create(w http.ResponseWriter, r *http.Request) {
	item := h.newItem()
	if err := json.NewDecoder(r.Body).Decode(item); err != nil {
		WriteError(w, "INVALID_INPUT", "invalid request body", http.StatusBadRequest)
		return
	}
	if h.validate != nil {
		if msg := h.validate(item); msg != "" {
			WriteError(w, "VALIDATION_ERROR", msg, http.StatusBadRequest)
			return
		}
	}
	if h.onCreate != nil {
		h.onCreate(item)
	}

	data, err := json.Marshal(item)
	if err != nil {
		slog.Error("encode "+h.collection, "error", err)
		WriteError(w, "INTERNAL_ERROR", "failed to encode data", http.StatusInternalServerError)
		return
	}
	id, err := h.store.Create(h.collection, data)
	if err != nil {
		slog.Error("create "+h.collection, "error", err)
		WriteError(w, "INTERNAL_ERROR", "failed to create "+h.collection, http.StatusInternalServerError)
		return
	}

	item.SetID(id)
	data, err = json.Marshal(item)
	if err != nil {
		slog.Error("encode "+h.collection+" with id", "error", err)
		WriteError(w, "INTERNAL_ERROR", "failed to encode data", http.StatusInternalServerError)
		return
	}
	if err := h.store.Update(h.collection, id, data); err != nil {
		slog.Error("persist id", "collection", h.collection, "id", id, "error", err)
		WriteError(w, "INTERNAL_ERROR", "failed to persist "+h.collection, http.StatusInternalServerError)
		return
	}
	WriteJSON(w, item, http.StatusCreated)
}

func (h *resource[T]) update(w http.ResponseWriter, r *http.Request) {
	id := r.PathValue("id")
	item := h.newItem()
	if err := json.NewDecoder(r.Body).Decode(item); err != nil {
		WriteError(w, "INVALID_INPUT", "invalid request body", http.StatusBadRequest)
		return
	}
	if h.validate != nil {
		if msg := h.validate(item); msg != "" {
			WriteError(w, "VALIDATION_ERROR", msg, http.StatusBadRequest)
			return
		}
	}
	item.SetID(id)
	if h.onUpdate != nil {
		h.onUpdate(item)
	}

	data, err := json.Marshal(item)
	if err != nil {
		slog.Error("encode "+h.collection, "error", err)
		WriteError(w, "INTERNAL_ERROR", "failed to encode data", http.StatusInternalServerError)
		return
	}
	if err := h.store.Update(h.collection, id, data); err != nil {
		WriteError(w, "NOT_FOUND", h.collection+" not found", http.StatusNotFound)
		return
	}
	WriteJSON(w, item, http.StatusOK)
}

func (h *resource[T]) delete(w http.ResponseWriter, r *http.Request) {
	id := r.PathValue("id")
	if err := h.store.Delete(h.collection, id); err != nil {
		WriteError(w, "NOT_FOUND", h.collection+" not found", http.StatusNotFound)
		return
	}
	w.WriteHeader(http.StatusNoContent)
}
