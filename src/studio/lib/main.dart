import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import './app/router.dart';

void main() {
  runApp(const _App());
}

class _App extends StatelessWidget {
  const _App();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '量潮数据',
      debugShowCheckedModeBanner: false,
      routerConfig: buildRouter(initialLocation: _webInitialLocation()),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4F46E5),
          surface: Colors.white,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF1F5F9),
        useMaterial3: true,
        fontFamily: 'NotoSansSC',
      ),
    );
  }
}

/// Web 下把浏览器地址作为初始路由显式传给 go_router（`Uri.base` 是唯一可信源：
/// 平台默认路由在这个构建里会退化成 `/`，深链冷启动曾落到列表页）。
///
/// 非 Web（测试、桌面）返回 null，走平台默认；测试用 buildRouter 的
/// [initialLocation] 注入入口地址。
String? _webInitialLocation() {
  if (!kIsWeb) return null;
  final u = Uri.base;
  final path = u.path.isEmpty ? '/' : u.path;
  return u.hasQuery ? '$path?${u.query}' : path;
}
