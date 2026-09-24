package model

// Task 是任务资源，JSON 字段沿用既有 API 的 camelCase 契约。
// Type 取值沿用四类：requirement / agreement / execution / acceptance。
type Task struct {
	ID          string `json:"id"`
	Title       string `json:"title"`
	Description string `json:"description,omitempty"`
	Type        string `json:"type"`
	Status      string `json:"status"`
	CreatedAt   string `json:"createdAt"`
	UpdatedAt   string `json:"updatedAt"`
}

func (t *Task) GetID() string { return t.ID }

func (t *Task) SetID(id string) { t.ID = id }
