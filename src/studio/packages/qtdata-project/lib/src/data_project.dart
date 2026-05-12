enum StageType {
  requirementExploration('需求探索与评估', 1),
  agreementAndLaunch('约定与启动', 2),
  executionAndMonitoring('执行与监控', 3),
  changeManagement('变更管理', 4),
  acceptanceAndDelivery('验收与交付', 5);

  final String label;
  final int order;
  const StageType(this.label, this.order);
}

class ProjectStage {
  final StageType type;
  final String clientResponsibility;
  final String partnerResponsibility;
  final String collaborationOutput;

  const ProjectStage({
    required this.type,
    this.clientResponsibility = '',
    this.partnerResponsibility = '',
    this.collaborationOutput = '',
  });
}

class DataProject {
  final String id;
  final String name;
  final String title;
  final String description;
  final List<ProjectStage> stages;

  const DataProject({
    required this.id,
    required this.name,
    required this.title,
    this.description = '',
    this.stages = const [],
  });
}
