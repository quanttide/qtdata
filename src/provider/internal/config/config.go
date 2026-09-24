package config

import (
	"encoding/json"
	"fmt"
	"os"

	"github.com/quanttide/qtdata-provider/internal/store"
)

// Config 是服务配置：JSON 文件（可选，经 CONFIG_PATH 指定）+ 环境变量覆盖。
type Config struct {
	Server ServerConfig `json:"server"`
	Store  store.Config `json:"store"`
	Log    LogConfig    `json:"log"`
}

type ServerConfig struct {
	Addr string `json:"addr"`
}

type LogConfig struct {
	Level  string `json:"level"`
	Format string `json:"format"`
}

// Load 读取配置：默认值 → JSON 文件（path 非空时）→ 环境变量逐项覆盖。
// 环境变量优先读 QTDATA_ 前缀，其次无前缀旧名。
func Load(path string) (*Config, error) {
	cfg := &Config{
		Server: ServerConfig{Addr: ":8000"},
		Store: store.Config{
			Driver: "file",
			Path:   "data",
		},
		Log: LogConfig{Level: "info", Format: "text"},
	}

	if path != "" {
		data, err := os.ReadFile(path)
		if err != nil {
			return nil, fmt.Errorf("read config: %w", err)
		}
		if err := json.Unmarshal(data, cfg); err != nil {
			return nil, fmt.Errorf("parse config: %w", err)
		}
	}

	cfg.Server.Addr = env("QTDATA_ADDR", "ADDR", cfg.Server.Addr)
	cfg.Store.Driver = env("QTDATA_STORE_DRIVER", "STORE_DRIVER", cfg.Store.Driver)
	cfg.Store.Path = env("QTDATA_STORE_PATH", "STORE_PATH", cfg.Store.Path)
	cfg.Log.Level = env("QTDATA_LOG_LEVEL", "LOG_LEVEL", cfg.Log.Level)
	cfg.Log.Format = env("QTDATA_LOG_FORMAT", "LOG_FORMAT", cfg.Log.Format)

	return cfg, nil
}

// env 依次读取前缀名与旧名，均未设置时返回默认值。
func env(key, legacyKey, def string) string {
	if v := os.Getenv(key); v != "" {
		return v
	}
	if v := os.Getenv(legacyKey); v != "" {
		return v
	}
	return def
}
