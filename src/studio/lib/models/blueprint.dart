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
