import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import './project.dart';

const String seedProjectsAsset = 'assets/data/seed_projects.json';

List<Project>? _seedList;
Future<List<Project>>? _cached;

/// 种子数据加载并缓存——Dashboard 与路由深链共用一份，只读一次 rootBundle。
///
/// 已加载完成后走同步路径（[seedProjectsIfLoaded] / `Future.value`），界面与
/// 路由优先同步取数，避免测试环境下悬挂的异步订阅（与 `test/helpers/seed.dart`
/// 同源的坑：rootBundle future 在 widget 测试里会挂死）。
/// 加载失败会清缓存，让下次调用（如 Dashboard 重试）重新读取。
Future<List<Project>> loadSeedProjects() {
  final ready = _seedList;
  if (ready != null) return Future<List<Project>>.value(ready);
  return _cached ??= _loadSeedProjects();
}

/// 已加载完成的种子数据；未加载（或加载失败）时为 null。
List<Project>? seedProjectsIfLoaded() => _seedList;

/// 测试专用：同步预灌缓存，让用例完全不经过 rootBundle。
@visibleForTesting
void setSeedCacheForTest(List<Project> projects) {
  _seedList = projects;
  _cached = Future<List<Project>>.value(projects);
}

/// 测试专用：清掉缓存。
@visibleForTesting
void resetSeedCacheForTest() {
  _seedList = null;
  _cached = null;
}

Future<List<Project>> _loadSeedProjects() async {
  try {
    final raw = await rootBundle.loadString(seedProjectsAsset);
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final list = (decoded['projects'] as List<dynamic>)
        .map((e) => Project.fromJson(e as Map<String, dynamic>))
        .toList();
    _seedList = list;
    return list;
  } catch (_) {
    _seedList = null;
    _cached = null;
    rethrow;
  }
}
