package api

import "net/http"

// Health 是全局健康检查端点，响应体约定为 {"status": "ok"}。
func Health(w http.ResponseWriter, r *http.Request) {
	WriteJSON(w, map[string]string{"status": "ok"}, http.StatusOK)
}
