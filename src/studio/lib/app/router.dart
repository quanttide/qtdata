import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../project/models/project.dart';
import '../../project/models/seed_loader.dart';
import '../../project/screens/dashboard_screen.dart';
import './screens/project_detail_screen.dart';

/// 路由表（平台契约：Studio 统一用 go_router）。
///
/// - `/`                          项目列表（「我的项目」）
/// - `/projects/:id?tab=<slug>`   项目详情，`tab` 深链直达对应 Tab（slug 见
///   [detailTabSlugs]），冷启动与站内跳转共用一条路径
///
/// [initialLocation] 非空时用 `overridePlatformDefaultLocation` 强制生效：
/// Web 构建里平台默认路由会退化成 `/`（深链冷启动曾落到列表页），生产入口
/// （`main.dart` 的 `_webInitialLocation`）从 `Uri.base` 取浏览器地址传进来；
/// 测试也通过本参数注入入口地址。
GoRouter buildRouter({String? initialLocation}) {
  return GoRouter(
    initialLocation: initialLocation,
    overridePlatformDefaultLocation: initialLocation != null,
    routes: <RouteBase>[
      GoRoute(path: '/', builder: (context, state) => const DashboardScreen()),
      GoRoute(
        path: '/projects/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          final tab = detailTabIndex(state.uri.queryParameters['tab']);
          final extra = state.extra;
          // 站内跳转带上 Project，免一次异步加载；深链/刷新走缓存加载
          if (extra is Project && extra.id == id) {
            return ProjectDetailScreen(project: extra, initialTab: tab);
          }
          // 已加载过：同步渲染，不挂 FutureBuilder（测试环境异步会悬挂）
          final ready = seedProjectsIfLoaded();
          if (ready != null) {
            final match = ready.where((p) => p.id == id);
            if (match.isEmpty) return const DashboardScreen();
            return ProjectDetailScreen(project: match.first, initialTab: tab);
          }
          return FutureBuilder<List<Project>>(
            future: loadSeedProjects(),
            builder: (context, snap) {
              if (snap.connectionState != ConnectionState.done) {
                return const Scaffold(
                  backgroundColor: Color(0xFFF1F5F9),
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              final projects = snap.data ?? const <Project>[];
              final match = projects.where((p) => p.id == id);
              // 未知 id 或数据加载失败都退回列表页
              if (snap.hasError || match.isEmpty) {
                return const DashboardScreen();
              }
              return ProjectDetailScreen(project: match.first, initialTab: tab);
            },
          );
        },
      ),
    ],
  );
}
