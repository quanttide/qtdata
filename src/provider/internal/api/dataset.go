package api

import (
	"net/http"

	"github.com/quanttide/qtdata-provider/internal/model"
	"github.com/quanttide/qtdata-provider/internal/store"
)

// RegisterDatasetRoutes 挂载数据集 CRUD：/api/v1/qtdata/datasets。
// 路由与语义沿用 examples/dataset-api 参考实现，2026-09-24 整合回 provider。
func RegisterDatasetRoutes(mux *http.ServeMux, st store.Store) {
	h := &resource[*model.QtDataDataset]{
		store:      st,
		collection: "qtdata/datasets",
		newItem:    func() *model.QtDataDataset { return new(model.QtDataDataset) },
		validate: func(d *model.QtDataDataset) string {
			if d.Name == "" {
				return "name is required"
			}
			return ""
		},
		onCreate: func(d *model.QtDataDataset) {
			if d.CreatedAt == "" {
				d.CreatedAt = nowRFC3339()
			}
		},
	}
	mux.HandleFunc("GET /api/v1/qtdata/datasets", h.list)
	mux.HandleFunc("POST /api/v1/qtdata/datasets", h.create)
	mux.HandleFunc("GET /api/v1/qtdata/datasets/{id}", h.get)
	mux.HandleFunc("PUT /api/v1/qtdata/datasets/{id}", h.update)
	mux.HandleFunc("DELETE /api/v1/qtdata/datasets/{id}", h.delete)
}
