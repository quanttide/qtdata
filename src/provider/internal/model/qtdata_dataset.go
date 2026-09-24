package model

// QtDataDataset 是数据集资源，JSON 字段沿用 /api/v1/qtdata/datasets 既有契约（snake_case）。
type QtDataDataset struct {
	ID          string `json:"id"`
	Name        string `json:"name"`
	Description string `json:"description"`
	Version     string `json:"version"`
	Status      string `json:"status"`
	CreatedAt   string `json:"created_at"`
}

func (d *QtDataDataset) GetID() string { return d.ID }

func (d *QtDataDataset) SetID(id string) { d.ID = id }
