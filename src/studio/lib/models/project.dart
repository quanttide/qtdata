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
  done('done'),
  active('active'),
  waiting('waiting'),
  todo('todo');

  final String key;
  const ItemStatus(this.key);

  bool get isDone => this == done;
  bool get isActive => this == active;
}

class DeliveryItem {
  final String name;
  final ItemStatus status;
  final String dim;

  const DeliveryItem({
    required this.name,
    required this.status,
    required this.dim,
  });
}

class DeliveryTarget {
  final String phase;
  final List<DeliveryItem> items;

  const DeliveryTarget({required this.phase, required this.items});
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
  final String type;

  const PhaseItem({
    required this.name,
    required this.desc,
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
  final int contractMonths;
  final String status;
  final ProjectPhase currentPhase;
  final List<DeliveryTarget> deliveryTarget;
  final Blueprint blueprint;
  final List<ProjectPhaseDetail> phases;

  const Project({
    required this.name,
    required this.client,
    required this.created,
    this.contractMonths = 1,
    required this.status,
    required this.currentPhase,
    required this.deliveryTarget,
    required this.blueprint,
    required this.phases,
  });

  int get totalItems =>
      deliveryTarget.fold(0, (s, dt) => s + dt.items.length);

  int get doneItems => deliveryTarget.fold(
        0,
        (s, dt) => s + dt.items.where((i) => i.status.isDone).length,
      );

  int get progressPercent =>
      totalItems > 0 ? ((doneItems / totalItems) * 100).round() : 0;

  int get elapsedDays =>
      ((progressPercent / 100) * contractMonths * 30).round();

  int get totalDays => contractMonths * 30;
}
