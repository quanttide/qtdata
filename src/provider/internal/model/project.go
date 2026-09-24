package model

// Project 是数据项目资源，JSON 字段沿用既有 API 的 camelCase 契约。
type Project struct {
	ID        string `json:"id"`
	Name      string `json:"name"`
	Title     string `json:"title"`
	CreatedBy string `json:"createdBy,omitempty"`
	CreatedAt string `json:"createdAt"`
	UpdatedAt string `json:"updatedAt"`
}

func (p *Project) GetID() string { return p.ID }

func (p *Project) SetID(id string) { p.ID = id }
