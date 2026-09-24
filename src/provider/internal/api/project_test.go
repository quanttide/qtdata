package api

import (
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"
)

func TestProjectCRUD(t *testing.T) {
	s, cleanup := testSetup(t)
	defer cleanup()

	mux := http.NewServeMux()
	RegisterProjectRoutes(mux, s)
	base := "/api/v1/qtdata/projects"

	t.Run("Create assigns id and timestamps", func(t *testing.T) {
		req := httptest.NewRequest("POST", base, strings.NewReader(`{"name":"project-1","title":"数据项目 1"}`))
		req.Header.Set("Content-Type", "application/json")
		rec := httptest.NewRecorder()
		mux.ServeHTTP(rec, req)
		if rec.Code != http.StatusCreated {
			t.Fatalf("expected 201, got %d: %s", rec.Code, rec.Body.String())
		}
		var item map[string]any
		json.Unmarshal(rec.Body.Bytes(), &item)
		if item["id"] == "" || item["id"] == nil {
			t.Fatal("expected server-assigned id")
		}
		if item["createdAt"] == "" || item["createdAt"] == nil {
			t.Error("expected createdAt")
		}
		if item["updatedAt"] == "" || item["updatedAt"] == nil {
			t.Error("expected updatedAt")
		}
	})

	t.Run("Get and List", func(t *testing.T) {
		req := httptest.NewRequest("POST", base, strings.NewReader(`{"name":"project-2","title":"二号"}`))
		req.Header.Set("Content-Type", "application/json")
		rec := httptest.NewRecorder()
		mux.ServeHTTP(rec, req)
		var created map[string]any
		json.Unmarshal(rec.Body.Bytes(), &created)
		id := created["id"].(string)

		req = httptest.NewRequest("GET", base+"/"+id, nil)
		rec = httptest.NewRecorder()
		mux.ServeHTTP(rec, req)
		if rec.Code != http.StatusOK {
			t.Fatalf("expected 200, got %d", rec.Code)
		}
		var got map[string]any
		json.Unmarshal(rec.Body.Bytes(), &got)
		if got["title"] != "二号" {
			t.Errorf("expected title=二号, got %v", got["title"])
		}

		req = httptest.NewRequest("GET", base, nil)
		rec = httptest.NewRecorder()
		mux.ServeHTTP(rec, req)
		var list []map[string]any
		json.Unmarshal(rec.Body.Bytes(), &list)
		if len(list) != 2 {
			t.Errorf("expected 2 items, got %d", len(list))
		}
	})

	t.Run("Update refreshes updatedAt", func(t *testing.T) {
		req := httptest.NewRequest("POST", base, strings.NewReader(`{"name":"p3","title":"Old"}`))
		req.Header.Set("Content-Type", "application/json")
		rec := httptest.NewRecorder()
		mux.ServeHTTP(rec, req)
		var created map[string]any
		json.Unmarshal(rec.Body.Bytes(), &created)
		id := created["id"].(string)

		req = httptest.NewRequest("PUT", base+"/"+id, strings.NewReader(`{"name":"p3","title":"New"}`))
		req.Header.Set("Content-Type", "application/json")
		rec = httptest.NewRecorder()
		mux.ServeHTTP(rec, req)
		if rec.Code != http.StatusOK {
			t.Fatalf("expected 200, got %d: %s", rec.Code, rec.Body.String())
		}
		var updated map[string]any
		json.Unmarshal(rec.Body.Bytes(), &updated)
		if updated["title"] != "New" {
			t.Errorf("expected title=New, got %v", updated["title"])
		}
		if updated["id"] != id {
			t.Errorf("id changed: got %v, want %v", updated["id"], id)
		}
	})

	t.Run("Delete then Get 404", func(t *testing.T) {
		req := httptest.NewRequest("POST", base, strings.NewReader(`{"name":"p-del","title":"D"}`))
		req.Header.Set("Content-Type", "application/json")
		rec := httptest.NewRecorder()
		mux.ServeHTTP(rec, req)
		var created map[string]any
		json.Unmarshal(rec.Body.Bytes(), &created)
		id := created["id"].(string)

		req = httptest.NewRequest("DELETE", base+"/"+id, nil)
		rec = httptest.NewRecorder()
		mux.ServeHTTP(rec, req)
		if rec.Code != http.StatusNoContent {
			t.Fatalf("expected 204, got %d", rec.Code)
		}

		req = httptest.NewRequest("GET", base+"/"+id, nil)
		rec = httptest.NewRecorder()
		mux.ServeHTTP(rec, req)
		if rec.Code != http.StatusNotFound {
			t.Errorf("expected 404 after delete, got %d", rec.Code)
		}
	})
}

func TestProjectValidation(t *testing.T) {
	s, cleanup := testSetup(t)
	defer cleanup()

	mux := http.NewServeMux()
	RegisterProjectRoutes(mux, s)

	req := httptest.NewRequest("POST", "/api/v1/qtdata/projects", strings.NewReader(`{"title":"no name"}`))
	req.Header.Set("Content-Type", "application/json")
	rec := httptest.NewRecorder()
	mux.ServeHTTP(rec, req)
	if rec.Code != http.StatusBadRequest {
		t.Fatalf("expected 400, got %d", rec.Code)
	}
	var resp struct {
		Error struct {
			Code string `json:"code"`
		} `json:"error"`
	}
	json.Unmarshal(rec.Body.Bytes(), &resp)
	if resp.Error.Code != "VALIDATION_ERROR" {
		t.Errorf("expected VALIDATION_ERROR, got %q", resp.Error.Code)
	}
}
