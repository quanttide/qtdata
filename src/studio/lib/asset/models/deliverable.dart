import '../../app/models/project_status.dart';

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
