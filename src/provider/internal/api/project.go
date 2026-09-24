package api

import (
	"net/http"

	"github.com/quanttide/qtdata-provider/internal/model"
	"github.com/quanttide/qtdata-provider/internal/store"
)

// RegisterProjectRoutes 挂载项目 CRUD：/api/v1/qtdata/projects。
// 接续 Python 版 Project 能力（createdAt / updatedAt 由服务端维护）。
func RegisterProjectRoutes(mux *http.ServeMux, st store.Store) {
	h := &resource[*model.Project]{
		store:      st,
		collection: "qtdata/projects",
		newItem:    func() *model.Project { return new(model.Project) },
		validate: func(p *model.Project) string {
			if p.Name == "" {
				return "name is required"
			}
			return ""
		},
		onCreate: func(p *model.Project) {
			now := nowRFC3339()
			p.CreatedAt = now
			p.UpdatedAt = now
		},
		onUpdate: func(p *model.Project) {
			p.UpdatedAt = nowRFC3339()
		},
	}
	mux.HandleFunc("GET /api/v1/qtdata/projects", h.list)
	mux.HandleFunc("POST /api/v1/qtdata/projects", h.create)
	mux.HandleFunc("GET /api/v1/qtdata/projects/{id}", h.get)
	mux.HandleFunc("PUT /api/v1/qtdata/projects/{id}", h.update)
	mux.HandleFunc("DELETE /api/v1/qtdata/projects/{id}", h.delete)
}
