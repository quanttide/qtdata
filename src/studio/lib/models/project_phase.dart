import 'project_status.dart';

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
