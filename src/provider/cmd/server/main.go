package main

import (
	"context"
	"log/slog"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/quanttide/qtdata-provider/internal/api"
	"github.com/quanttide/qtdata-provider/internal/config"
	"github.com/quanttide/qtdata-provider/internal/store"
)

// qtdata provider：服务骨架（config/store/日志/优雅关闭）+ qtdata 领域 CRUD。
//
// 领域路由在下方注册点挂载；数据集域于 2026-09-24 自 examples/dataset-api 整合回本服务
// （该实现原自 qtadmin provider 拆出）。
func main() {
	cfgPath := os.Getenv("CONFIG_PATH")
	cfg, err := config.Load(cfgPath)
	if err != nil {
		slog.Error("failed to load config", "error", err)
		os.Exit(1)
	}

	setupLogger(cfg.Log)
	slog.Info("config loaded", "addr", cfg.Server.Addr, "store", cfg.Store)

	st, err := store.New(cfg.Store)
	if err != nil {
		slog.Error("failed to initialize store", "error", err)
		os.Exit(1)
	}
	defer st.Close()
	slog.Info("store initialized", "driver", cfg.Store.Driver, "path", cfg.Store.Path)

	mux := http.NewServeMux()
	mux.HandleFunc("GET /health", api.Health)

	// 领域路由注册点
	api.RegisterDatasetRoutes(mux, st)
	api.RegisterProjectRoutes(mux, st)
	api.RegisterTaskRoutes(mux, st)

	handler := loggingMiddleware(mux)

	srv := &http.Server{Addr: cfg.Server.Addr, Handler: handler}

	go func() {
		slog.Info("listening", "addr", cfg.Server.Addr)
		if err := srv.ListenAndServe(); err != nil && err != http.ErrServerClosed {
			slog.Error("server error", "error", err)
			os.Exit(1)
		}
	}()

	quit := make(chan os.Signal, 1)
	signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
	<-quit

	slog.Info("shutting down")
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()
	srv.Shutdown(ctx)
}

func setupLogger(lc config.LogConfig) {
	var level slog.Level
	switch lc.Level {
	case "debug":
		level = slog.LevelDebug
	case "info":
		level = slog.LevelInfo
	case "warn":
		level = slog.LevelWarn
	case "error":
		level = slog.LevelError
	default:
		level = slog.LevelInfo
	}

	opts := &slog.HandlerOptions{Level: level}

	var h slog.Handler
	if lc.Format == "json" {
		h = slog.NewJSONHandler(os.Stdout, opts)
	} else {
		h = slog.NewTextHandler(os.Stdout, opts)
	}
	slog.SetDefault(slog.New(h))
}

func loggingMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		start := time.Now()
		slog.Info("request", "method", r.Method, "path", r.URL.Path)
		next.ServeHTTP(w, r)
		slog.Info("response", "method", r.Method, "path", r.URL.Path, "duration", time.Since(start))
	})
}
