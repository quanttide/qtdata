import 'package:flutter/foundation.dart';
import '../process_flow.dart';
import '../process_stage.dart';
import '../process_status.dart';

class ProcessState extends ChangeNotifier {
  ProcessFlow? _flow;

  ProcessFlow? get flow => _flow;

  void loadFlow(ProcessFlow flow) {
    _flow = flow;
    notifyListeners();
  }

  void updateStageStatus(String stageId, ProcessStatus status) {
    if (_flow == null) {
      return;
    }
    _flow = ProcessFlow(
      id: _flow!.id,
      name: _flow!.name,
      stages: _flow!.stages.map((s) {
        if (s.id == stageId) {
          return ProcessStage(
            id: s.id,
            name: s.name,
            order: s.order,
            status: status,
          );
        }
        return s;
      }).toList(),
      status: status,
    );
    notifyListeners();
  }
}
