import 'package:flutter/material.dart' show Color;

enum ProjectPhase {
  research('调研'),
  negotiate('谈判'),
  implement('实施'),
  accept('验收'),
  review('复盘');

  final String label;
  const ProjectPhase(this.label);

  static ProjectPhase fromLabel(String label) {
    return ProjectPhase.values.firstWhere(
      (p) => p.label == label,
      orElse: () => ProjectPhase.research,
    );
  }

  /// 按枚举名（JSON seed 中的 currentPhase 键）解析
  static ProjectPhase fromKey(String key) => ProjectPhase.values.firstWhere(
    (p) => p.name == key,
    orElse: () => ProjectPhase.research,
  );
}

enum ItemStatus {
  done('已完成'),
  active('进行中'),
  todo('待启动');

  final String label;
  const ItemStatus(this.label);

  bool get isDone => this == done;
  bool get isActive => this == active;

  /// 按枚举名（JSON seed 中的 status 键）解析
  static ItemStatus fromKey(String key) => ItemStatus.values.firstWhere(
    (s) => s.name == key,
    orElse: () => ItemStatus.todo,
  );
}

/// 状态三态语义色（主色/徽章底色/徽章前景色），各组件共用
/// 归一点：todo 浅灰 D1D5DB/E2E8F0 → 94A3B8；active 3B82F6 → 品牌靛蓝 4F46E5

extension ItemStatusColors on ItemStatus {
  /// 状态主色（圆点、边框、强调线）
  Color get color => switch (this) {
    ItemStatus.done => const Color(0xFF10B981),
    ItemStatus.active => const Color(0xFF4F46E5),
    ItemStatus.todo => const Color(0xFF94A3B8),
  };

  /// 状态徽章底色
  Color get badgeBg => switch (this) {
    ItemStatus.done => const Color(0xFFD1FAE5),
    ItemStatus.active => const Color(0xFFDBEAFE),
    ItemStatus.todo => const Color(0xFFF1F5F9),
  };

  /// 状态徽章前景色
  Color get badgeFg => switch (this) {
    ItemStatus.done => const Color(0xFF065F46),
    ItemStatus.active => const Color(0xFF1D4ED8),
    ItemStatus.todo => const Color(0xFF94A3B8),
  };
}
