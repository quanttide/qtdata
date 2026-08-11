package api

import (
	"encoding/json"
	"log/slog"
	"net/http"

	"github.com/quanttide/qtdata-provider-example/internal/model"
	"github.com/quanttide/qtdata-provider-example/internal/store"
)

type DatasetHandler struct {
	store store.Store
}

func NewDatasetHandler(st store.Store) *DatasetHandler {
	return &DatasetHandler{store: st}
}

// --- QtData Datasets ---

func (h *DatasetHandler) ListDatasets(w http.ResponseWriter, r *http.Request) {
	data, err := h.store.List("qtdata/datasets")
	if err != nil {
		slog.Error("list datasets", "error", err)
		WriteError(w, "INTERNAL_ERROR", "failed to list datasets", http.StatusInternalServerError)
		return
	}
	var items []model.QtDataDataset
	if err := json.Unmarshal(data, &items); err != nil {
		slog.Error("parse datasets", "error", err)
		WriteError(w, "INTERNAL_ERROR", "failed to parse datasets", http.StatusInternalServerError)
		return
	}
	WriteJSON(w, items, http.StatusOK)
}

func (h *DatasetHandler) CreateDataset(w http.ResponseWriter, r *http.Request) {
	var item model.QtDataDataset
	if err := json.NewDecoder(r.Body).Decode(&item); err != nil {
		WriteError(w, "INVALID_INPUT", "invalid request body", http.StatusBadRequest)
		return
	}
	if item.Name == "" {
		WriteError(w, "VALIDATION_ERROR", "name is required", http.StatusBadRequest)
		return
	}

	data, err := json.Marshal(item)
	if err != nil {
		slog.Error("encode dataset", "error", err)
		WriteError(w, "INTERNAL_ERROR", "failed to encode data", http.StatusInternalServerError)
		return
	}

	id, err := h.store.Create("qtdata/datasets", data)
	if err != nil {
		slog.Error("create dataset", "error", err)
		WriteError(w, "INTERNAL_ERROR", "failed to create dataset", http.StatusInternalServerError)
		return
	}

	item.ID = id
	data, err = json.Marshal(item)
	if err != nil {
		slog.Error("encode dataset with id", "error", err)
		WriteError(w, "INTERNAL_ERROR", "failed to encode data", http.StatusInternalServerError)
		return
	}
	if err := h.store.Update("qtdata/datasets", id, data); err != nil {
		slog.Error("persist dataset id", "error", err)
	}

	WriteJSON(w, item, http.StatusCreated)
}

func (h *DatasetHandler) GetDataset(w http.ResponseWriter, r *http.Request) {
	id := r.PathValue("id")
	data, err := h.store.Get("qtdata/datasets", id)
	if err != nil {
		WriteError(w, "NOT_FOUND", "dataset not found", http.StatusNotFound)
		return
	}
	var item model.QtDataDataset
	if err := json.Unmarshal(data, &item); err != nil {
		slog.Error("parse dataset", "error", err)
		WriteError(w, "INTERNAL_ERROR", "failed to parse dataset", http.StatusInternalServerError)
		return
	}
	WriteJSON(w, item, http.StatusOK)
}

func (h *DatasetHandler) UpdateDataset(w http.ResponseWriter, r *http.Request) {
	id := r.PathValue("id")
	var item model.QtDataDataset
	if err := json.NewDecoder(r.Body).Decode(&item); err != nil {
		WriteError(w, "INVALID_INPUT", "invalid request body", http.StatusBadRequest)
		return
	}
	item.ID = id

	data, err := json.Marshal(item)
	if err != nil {
		slog.Error("encode dataset", "error", err)
		WriteError(w, "INTERNAL_ERROR", "failed to encode data", http.StatusInternalServerError)
		return
	}
	if err := h.store.Update("qtdata/datasets", id, data); err != nil {
		WriteError(w, "NOT_FOUND", "dataset not found", http.StatusNotFound)
		return
	}
	WriteJSON(w, item, http.StatusOK)
}

func (h *DatasetHandler) DeleteDataset(w http.ResponseWriter, r *http.Request) {
	id := r.PathValue("id")
	if err := h.store.Delete("qtdata/datasets", id); err != nil {
		WriteError(w, "NOT_FOUND", "dataset not found", http.StatusNotFound)
		return
	}
	w.WriteHeader(http.StatusNoContent)
}
