import 'process_stage.dart';
import 'process_status.dart';

class ProcessFlow {
  final String id;
  final String name;
  final List<ProcessStage> stages;
  final ProcessStatus status;

  const ProcessFlow({
    required this.id,
    required this.name,
    required this.stages,
    this.status = ProcessStatus.pending,
  });
}
