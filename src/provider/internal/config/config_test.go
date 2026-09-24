package config

import (
	"os"
	"testing"
)

func TestMain(m *testing.M) {
	for _, k := range []string{
		"QTDATA_ADDR", "ADDR",
		"QTDATA_STORE_DRIVER", "STORE_DRIVER",
		"QTDATA_STORE_PATH", "STORE_PATH",
		"QTDATA_LOG_LEVEL", "LOG_LEVEL",
		"QTDATA_LOG_FORMAT", "LOG_FORMAT",
	} {
		os.Unsetenv(k)
	}
	os.Exit(m.Run())
}

func TestLoadDefaults(t *testing.T) {
	cfg, err := Load("")
	if err != nil {
		t.Fatalf("Load empty path: %v", err)
	}
	if cfg.Server.Addr != ":8000" {
		t.Errorf("addr: got %q, want %q", cfg.Server.Addr, ":8000")
	}
	if cfg.Store.Driver != "file" {
		t.Errorf("store driver: got %q, want %q", cfg.Store.Driver, "file")
	}
	if cfg.Store.Path != "data" {
		t.Errorf("store path: got %q, want %q", cfg.Store.Path, "data")
	}
	if cfg.Log.Level != "info" {
		t.Errorf("log level: got %q, want %q", cfg.Log.Level, "info")
	}
	if cfg.Log.Format != "text" {
		t.Errorf("log format: got %q, want %q", cfg.Log.Format, "text")
	}
}

func TestLoadEnvOverride(t *testing.T) {
	t.Setenv("QTDATA_ADDR", ":9001")
	t.Setenv("QTDATA_STORE_PATH", "/tmp/qtdata-store")

	cfg, err := Load("")
	if err != nil {
		t.Fatalf("Load with env: %v", err)
	}
	if cfg.Server.Addr != ":9001" {
		t.Errorf("addr: got %q, want %q", cfg.Server.Addr, ":9001")
	}
	if cfg.Store.Path != "/tmp/qtdata-store" {
		t.Errorf("store path: got %q, want %q", cfg.Store.Path, "/tmp/qtdata-store")
	}
}

func TestLoadLegacyEnv(t *testing.T) {
	t.Setenv("ADDR", ":9002")

	cfg, err := Load("")
	if err != nil {
		t.Fatalf("Load with legacy env: %v", err)
	}
	if cfg.Server.Addr != ":9002" {
		t.Errorf("addr: got %q, want %q", cfg.Server.Addr, ":9002")
	}
}

func TestLoadJSONFile(t *testing.T) {
	f, err := os.CreateTemp("", "cfg-*.json")
	if err != nil {
		t.Fatalf("create temp config: %v", err)
	}
	defer os.Remove(f.Name())
	f.WriteString(`{"server":{"addr":":7000"},"log":{"level":"debug"}}`)
	f.Close()

	cfg, err := Load(f.Name())
	if err != nil {
		t.Fatalf("Load from file: %v", err)
	}
	if cfg.Server.Addr != ":7000" {
		t.Errorf("addr: got %q, want %q", cfg.Server.Addr, ":7000")
	}
	if cfg.Log.Level != "debug" {
		t.Errorf("log level: got %q, want %q", cfg.Log.Level, "debug")
	}
	if cfg.Store.Driver != "file" {
		t.Errorf("store driver should keep default, got %q", cfg.Store.Driver)
	}
}
