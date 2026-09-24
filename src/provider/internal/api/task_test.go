package api

import (
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"
)

func TestTaskCRUD(t *testing.T) {
	s, cleanup := testSetup(t)
	defer cleanup()

	mux := http.NewServeMux()
	RegisterTaskRoutes(mux, s)
	base := "/api/v1/qtdata/tasks"

	t.Run("Create and Get roundtrip", func(t *testing.T) {
		body := `{"title":"数据清理ETL开发","description":"去重、缺失值处理","type":"execution","status":"doing"}`
		req := httptest.NewRequest("POST", base, strings.NewReader(body))
		req.Header.Set("Content-Type", "application/json")
		rec := httptest.NewRecorder()
		mux.ServeHTTP(rec, req)
		if rec.Code != http.StatusCreated {
			t.Fatalf("expected 201, got %d: %s", rec.Code, rec.Body.String())
		}
		var created map[string]any
		json.Unmarshal(rec.Body.Bytes(), &created)
		if created["type"] != "execution" || created["status"] != "doing" {
			t.Errorf("type/status roundtrip failed: %v/%v", created["type"], created["status"])
		}
		if created["createdAt"] == "" || created["createdAt"] == nil {
			t.Error("expected createdAt")
		}
		id := created["id"].(string)

		req = httptest.NewRequest("GET", base+"/"+id, nil)
		rec = httptest.NewRecorder()
		mux.ServeHTTP(rec, req)
		if rec.Code != http.StatusOK {
			t.Fatalf("expected 200, got %d", rec.Code)
		}
		var got map[string]any
		json.Unmarshal(rec.Body.Bytes(), &got)
		if got["title"] != "数据清理ETL开发" {
			t.Errorf("expected title roundtrip, got %v", got["title"])
		}
	})

	t.Run("Create without title rejected", func(t *testing.T) {
		req := httptest.NewRequest("POST", base, strings.NewReader(`{"type":"requirement","status":"pending"}`))
		req.Header.Set("Content-Type", "application/json")
		rec := httptest.NewRecorder()
		mux.ServeHTTP(rec, req)
		if rec.Code != http.StatusBadRequest {
			t.Errorf("expected 400, got %d", rec.Code)
		}
	})

	t.Run("Create invalid json rejected", func(t *testing.T) {
		req := httptest.NewRequest("POST", base, strings.NewReader(`{`))
		req.Header.Set("Content-Type", "application/json")
		rec := httptest.NewRecorder()
		mux.ServeHTTP(rec, req)
		if rec.Code != http.StatusBadRequest {
			t.Errorf("expected 400, got %d", rec.Code)
		}
		var resp struct {
			Error struct {
				Code string `json:"code"`
			} `json:"error"`
		}
		json.Unmarshal(rec.Body.Bytes(), &resp)
		if resp.Error.Code != "INVALID_INPUT" {
			t.Errorf("expected INVALID_INPUT, got %q", resp.Error.Code)
		}
	})
}
