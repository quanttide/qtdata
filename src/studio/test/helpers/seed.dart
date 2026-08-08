import 'dart:convert';
import 'dart:io';

import 'package:qtdata_studio/models/project.dart';

/// 从仓库 seed JSON 同步构造测试用 Project。
///
/// widget 测试运行在包根目录（src/studio/），可直接读文件系统；
/// 不走 rootBundle 以避免测试环境下的异步 IO future 悬挂。
Project loadSeedProject() {
  final raw = File('assets/data/seed_projects.json').readAsStringSync();
  final decoded = jsonDecode(raw) as Map<String, dynamic>;
  return Project.fromJson(
    (decoded['projects'] as List<dynamic>).first as Map<String, dynamic>,
  );
}
