import 'blueprint.dart';
import 'business_info.dart';
import 'project_matrix.dart';
import 'project_phase.dart';
import 'project_status.dart';

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
