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
}

enum ItemStatus {
  done('已完成'),
  active('进行中'),
  todo('待启动');

  final String label;
  const ItemStatus(this.label);

  bool get isDone => this == done;
  bool get isActive => this == active;
}

/// 交付物（首页卡片上的交付物仪表）
class Deliverable {
  final String name;
  final ItemStatus status;

  const Deliverable({required this.name, required this.status});
}

/// 全流程进度总览（二维网格）的维度行
class MatrixRow {
  final String label;
  final String key;

  const MatrixRow({required this.label, required this.key});
}

/// 全流程进度总览（二维网格）的阶段列
class MatrixColumn {
  final String label;
  final String key;
  final ItemStatus status;

  const MatrixColumn({
    required this.label,
    required this.key,
    required this.status,
  });
}

/// 全流程进度总览（二维网格）的单元格
class MatrixCell {
  final String name;
  final ItemStatus status;

  const MatrixCell({required this.name, required this.status});
}

/// 全流程进度总览（二维网格）
class ProjectMatrix {
  final List<MatrixRow> rows;
  final List<MatrixColumn> columns;
  final Map<String, MatrixCell> cells;

  const ProjectMatrix({
    required this.rows,
    required this.columns,
    required this.cells,
  });

  /// 按 `行key_列key` 定位单元格
  MatrixCell? cellAt(String rowKey, String colKey) =>
      cells['${rowKey}_$colKey'];
}

class BlueprintStep {
  final String description;

  const BlueprintStep(this.description);
}

class BlueprintException {
  final String label;
  final String strategy;

  const BlueprintException({required this.label, required this.strategy});
}

class Blueprint {
  final List<BlueprintStep> steps;
  final List<BlueprintException> exceptions;

  const Blueprint({required this.steps, required this.exceptions});
}

class PhaseItem {
  final String name;
  final String desc;
  final bool hasDoc;
  final String type;

  const PhaseItem({
    required this.name,
    required this.desc,
    required this.hasDoc,
    required this.type,
  });
}

class ProjectPhaseDetail {
  final String name;
  final ItemStatus status;
  final List<PhaseItem> items;

  const ProjectPhaseDetail({
    required this.name,
    required this.status,
    required this.items,
  });
}

class Project {
  final String name;
  final String client;
  final String created;

  /// 卡片上的更新时间，如 2026-07-28
  final String updated;

  /// 状态文案：进行中 / 已完成 / 待启动
  final String status;
  final ProjectPhase currentPhase;

  /// 合同金额（万元）
  final double contractAmount;
  final List<Deliverable> deliverables;
  final ProjectMatrix matrix;
  final Blueprint blueprint;
  final List<ProjectPhaseDetail> phases;

  const Project({
    required this.name,
    required this.client,
    required this.created,
    required this.updated,
    required this.status,
    required this.currentPhase,
    required this.contractAmount,
    required this.deliverables,
    required this.matrix,
    required this.blueprint,
    required this.phases,
  });

  int get doneItems => deliverables.where((d) => d.status.isDone).length;
  int get activeItems => deliverables.where((d) => d.status.isActive).length;
  int get todoItems =>
      deliverables.where((d) => !d.status.isDone && !d.status.isActive).length;

  int get totalItems => deliverables.length;

  /// 交付完成度（0-100，四舍五入）
  int get progressPercent =>
      totalItems > 0 ? ((doneItems / totalItems) * 100).round() : 0;

  /// 已确认收入（万元）= 合同金额 × 完成度
  double get confirmedIncome =>
      totalItems > 0 ? contractAmount * (doneItems / totalItems) : 0;
}
