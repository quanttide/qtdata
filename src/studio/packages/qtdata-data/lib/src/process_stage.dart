import 'process_status.dart';

class ProcessStage {
  final String id;
  final String name;
  final int order;
  final ProcessStatus status;

  const ProcessStage({
    required this.id,
    required this.name,
    required this.order,
    this.status = ProcessStatus.pending,
  });
}
