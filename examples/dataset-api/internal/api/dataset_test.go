package api

import (
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"os"
	"strings"
	"testing"

	"github.com/quanttide/qtdata-provider-example/internal/store"
)

func testSetup(t *testing.T) (store.Store, func()) {
	t.Helper()
	dir, err := os.MkdirTemp("", "api-test-*")
	if err != nil {
		t.Fatalf("failed to create temp dir: %v", err)
	}
	s, err := store.New(store.Config{Driver: "file", Path: dir})
	if err != nil {
		os.RemoveAll(dir)
		t.Fatalf("failed to create store: %v", err)
	}
	return s, func() {
		s.Close()
		os.RemoveAll(dir)
	}
}

func registerDatasetRoutes(h *DatasetHandler) *http.ServeMux {
	mux := http.NewServeMux()
	// qtdata
	mux.HandleFunc("GET /api/v1/qtdata/datasets", h.ListDatasets)
	mux.HandleFunc("POST /api/v1/qtdata/datasets", h.CreateDataset)
	mux.HandleFunc("GET /api/v1/qtdata/datasets/{id}", h.GetDataset)
	mux.HandleFunc("PUT /api/v1/qtdata/datasets/{id}", h.UpdateDataset)
	mux.HandleFunc("DELETE /api/v1/qtdata/datasets/{id}", h.DeleteDataset)
	return mux
}

func TestDatasetCRUD(t *testing.T) {
	s, cleanup := testSetup(t)
	defer cleanup()

	h := NewDatasetHandler(s)
	mux := registerDatasetRoutes(h)
	base := "/api/v1/qtdata/datasets"

	t.Run("Create and Get", func(t *testing.T) {
		body := `{"name":"Sales Data","description":"Q1 sales figures","version":"1.0","status":"ready"}`
		req := httptest.NewRequest("POST", base, strings.NewReader(body))
		req.Header.Set("Content-Type", "application/json")
		rec := httptest.NewRecorder()
		mux.ServeHTTP(rec, req)
		if rec.Code != http.StatusCreated {
			t.Fatalf("expected 201, got %d", rec.Code)
		}

		var item map[string]any
		json.Unmarshal(rec.Body.Bytes(), &item)
		id := item["id"].(string)

		req = httptest.NewRequest("GET", base+"/"+id, nil)
		rec = httptest.NewRecorder()
		mux.ServeHTTP(rec, req)
		if rec.Code != http.StatusOK {
			t.Fatalf("expected 200, got %d", rec.Code)
		}
	})
}

func TestDatasetUpdateDelete(t *testing.T) {
	s, cleanup := testSetup(t)
	defer cleanup()

	h := NewDatasetHandler(s)
	mux := registerDatasetRoutes(h)
	base := "/api/v1/qtdata/datasets"

	t.Run("List empty", func(t *testing.T) {
		req := httptest.NewRequest("GET", base, nil)
		rec := httptest.NewRecorder()
		mux.ServeHTTP(rec, req)
		if rec.Code != http.StatusOK {
			t.Fatalf("expected 200, got %d", rec.Code)
		}
	})

	t.Run("Update", func(t *testing.T) {
		body := `{"name":"Sales Data","description":"Q1 sales","version":"1.0","status":"ready"}`
		req := httptest.NewRequest("POST", base, strings.NewReader(body))
		req.Header.Set("Content-Type", "application/json")
		rec := httptest.NewRecorder()
		mux.ServeHTTP(rec, req)
		var item map[string]any
		json.Unmarshal(rec.Body.Bytes(), &item)
		id := item["id"].(string)

		updateBody := `{"name":"Sales Data v2","description":"Updated Q1 sales","version":"2.0","status":"archived"}`
		req = httptest.NewRequest("PUT", base+"/"+id, strings.NewReader(updateBody))
		req.Header.Set("Content-Type", "application/json")
		rec = httptest.NewRecorder()
		mux.ServeHTTP(rec, req)
		if rec.Code != http.StatusOK {
			t.Fatalf("expected 200, got %d: %s", rec.Code, rec.Body.String())
		}
		var updated map[string]any
		json.Unmarshal(rec.Body.Bytes(), &updated)
		if updated["name"] != "Sales Data v2" {
			t.Errorf("expected name=Sales Data v2, got %v", updated["name"])
		}
	})

	t.Run("List after create", func(t *testing.T) {
		req := httptest.NewRequest("GET", base, nil)
		rec := httptest.NewRecorder()
		mux.ServeHTTP(rec, req)
		if rec.Code != http.StatusOK {
			t.Fatalf("expected 200, got %d", rec.Code)
		}
	})

	t.Run("Delete", func(t *testing.T) {
		body := `{"name":"Temp Dataset"}`
		req := httptest.NewRequest("POST", base, strings.NewReader(body))
		req.Header.Set("Content-Type", "application/json")
		rec := httptest.NewRecorder()
		mux.ServeHTTP(rec, req)
		var item map[string]any
		json.Unmarshal(rec.Body.Bytes(), &item)
		id := item["id"].(string)

		req = httptest.NewRequest("DELETE", base+"/"+id, nil)
		rec = httptest.NewRecorder()
		mux.ServeHTTP(rec, req)
		if rec.Code != http.StatusNoContent {
			t.Errorf("expected 204, got %d", rec.Code)
		}
	})

	t.Run("Delete not found", func(t *testing.T) {
		req := httptest.NewRequest("DELETE", base+"/nonexistent", nil)
		rec := httptest.NewRecorder()
		mux.ServeHTTP(rec, req)
		if rec.Code != http.StatusNotFound {
			t.Errorf("expected 404, got %d", rec.Code)
		}
	})
}
