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

/// 交付物（首页卡片上的交付物仪表）
class Deliverable {
  final String name;
  final ItemStatus status;

  const Deliverable({required this.name, required this.status});

  factory Deliverable.fromJson(Map<String, dynamic> json) => Deliverable(
    name: json['name'] as String,
    status: ItemStatus.fromKey(json['status'] as String),
  );
}

/// 全流程进度总览（二维网格）的维度行
class MatrixRow {
  final String label;
  final String key;

  const MatrixRow({required this.label, required this.key});

  factory MatrixRow.fromJson(Map<String, dynamic> json) =>
      MatrixRow(label: json['label'] as String, key: json['key'] as String);
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

  factory MatrixColumn.fromJson(Map<String, dynamic> json) => MatrixColumn(
    label: json['label'] as String,
    key: json['key'] as String,
    status: ItemStatus.fromKey(json['status'] as String),
  );
}

/// 全流程进度总览（二维网格）的单元格
class MatrixCell {
  final String name;
  final ItemStatus status;

  const MatrixCell({required this.name, required this.status});

  factory MatrixCell.fromJson(Map<String, dynamic> json) => MatrixCell(
    name: json['name'] as String,
    status: ItemStatus.fromKey(json['status'] as String),
  );
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

  factory ProjectMatrix.fromJson(Map<String, dynamic> json) => ProjectMatrix(
    rows: (json['rows'] as List<dynamic>)
        .map((e) => MatrixRow.fromJson(e as Map<String, dynamic>))
        .toList(),
    columns: (json['columns'] as List<dynamic>)
        .map((e) => MatrixColumn.fromJson(e as Map<String, dynamic>))
        .toList(),
    cells: (json['cells'] as Map<String, dynamic>).map(
      (key, value) =>
          MapEntry(key, MatrixCell.fromJson(value as Map<String, dynamic>)),
    ),
  );
}

class BlueprintStep {
  final String description;

  const BlueprintStep(this.description);

  factory BlueprintStep.fromJson(String description) =>
      BlueprintStep(description);
}

class BlueprintException {
  final String label;
  final String strategy;

  const BlueprintException({required this.label, required this.strategy});

  factory BlueprintException.fromJson(Map<String, dynamic> json) =>
      BlueprintException(
        label: json['label'] as String,
        strategy: json['strategy'] as String,
      );
}

class Blueprint {
  final List<BlueprintStep> steps;
  final List<BlueprintException> exceptions;

  const Blueprint({required this.steps, required this.exceptions});

  factory Blueprint.fromJson(Map<String, dynamic> json) => Blueprint(
    steps: (json['steps'] as List<dynamic>)
        .map((e) => BlueprintStep.fromJson(e as String))
        .toList(),
    exceptions: (json['exceptions'] as List<dynamic>)
        .map((e) => BlueprintException.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
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

  factory PhaseItem.fromJson(Map<String, dynamic> json) => PhaseItem(
    name: json['name'] as String,
    desc: json['desc'] as String,
    hasDoc: json['hasDoc'] as bool,
    type: json['type'] as String,
  );
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

  factory ProjectPhaseDetail.fromJson(Map<String, dynamic> json) =>
      ProjectPhaseDetail(
        name: json['name'] as String,
        status: ItemStatus.fromKey(json['status'] as String),
        items: (json['items'] as List<dynamic>)
            .map((e) => PhaseItem.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

/// 结款记录
class Payment {
  final String name;

  /// 金额（万元）
  final double amount;

  /// 已收 / 待收
  final String status;

  /// 到账日期（未收时为空串）
  final String date;

  const Payment({
    required this.name,
    required this.amount,
    required this.status,
    this.date = '',
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
    name: json['name'] as String,
    amount: (json['amount'] as num).toDouble(),
    status: json['status'] as String,
    date: json['date'] as String? ?? '',
  );
}

/// 商务信息：报价 → 合同 → 交付 → 结款
class BusinessInfo {
  /// 成本法报价（万元）
  final double costBased;

  /// 市场法报价（万元）
  final double marketBased;

  /// 定价依据说明
  final String pricingNote;

  /// 合同签订日期
  final String contractDate;

  /// 结款记录
  final List<Payment> payments;

  const BusinessInfo({
    required this.costBased,
    required this.marketBased,
    required this.pricingNote,
    required this.contractDate,
    required this.payments,
  });

  factory BusinessInfo.fromJson(Map<String, dynamic> json) => BusinessInfo(
    costBased: (json['costBased'] as num).toDouble(),
    marketBased: (json['marketBased'] as num).toDouble(),
    pricingNote: json['pricingNote'] as String? ?? '',
    contractDate: json['contractDate'] as String? ?? '',
    payments: (json['payments'] as List<dynamic>? ?? [])
        .map((e) => Payment.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

class Project {
  /// 种子数据标识（JSON seed 中的 id）
  final String id;
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

  /// 商务信息（报价/合同/结款），可为空
  final BusinessInfo? business;

  const Project({
    required this.id,
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
    this.business,
  });

  factory Project.fromJson(Map<String, dynamic> json) => Project(
    id: json['id'] as String,
    name: json['name'] as String,
    client: json['client'] as String,
    created: json['created'] as String,
    updated: json['updated'] as String,
    status: json['status'] as String,
    currentPhase: ProjectPhase.fromKey(json['currentPhase'] as String),
    contractAmount: (json['contractAmount'] as num).toDouble(),
    deliverables: (json['deliverables'] as List<dynamic>)
        .map((e) => Deliverable.fromJson(e as Map<String, dynamic>))
        .toList(),
    matrix: ProjectMatrix.fromJson(json['matrix'] as Map<String, dynamic>),
    blueprint: Blueprint.fromJson(json['blueprint'] as Map<String, dynamic>),
    phases: (json['phases'] as List<dynamic>)
        .map((e) => ProjectPhaseDetail.fromJson(e as Map<String, dynamic>))
        .toList(),
    business: json['business'] == null
        ? null
        : BusinessInfo.fromJson(json['business'] as Map<String, dynamic>),
  );

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
