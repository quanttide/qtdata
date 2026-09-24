package api

import (
	"net/http"

	"github.com/quanttide/qtdata-provider/internal/model"
	"github.com/quanttide/qtdata-provider/internal/store"
)

// RegisterTaskRoutes 挂载任务 CRUD：/api/v1/qtdata/tasks。
// 接续 Python 版 Task 能力（createdAt / updatedAt 由服务端维护）。
func RegisterTaskRoutes(mux *http.ServeMux, st store.Store) {
	h := &resource[*model.Task]{
		store:      st,
		collection: "qtdata/tasks",
		newItem:    func() *model.Task { return new(model.Task) },
		validate: func(t *model.Task) string {
			if t.Title == "" {
				return "title is required"
			}
			return ""
		},
		onCreate: func(t *model.Task) {
			now := nowRFC3339()
			t.CreatedAt = now
			t.UpdatedAt = now
		},
		onUpdate: func(t *model.Task) {
			t.UpdatedAt = nowRFC3339()
		},
	}
	mux.HandleFunc("GET /api/v1/qtdata/tasks", h.list)
	mux.HandleFunc("POST /api/v1/qtdata/tasks", h.create)
	mux.HandleFunc("GET /api/v1/qtdata/tasks/{id}", h.get)
	mux.HandleFunc("PUT /api/v1/qtdata/tasks/{id}", h.update)
	mux.HandleFunc("DELETE /api/v1/qtdata/tasks/{id}", h.delete)
}
