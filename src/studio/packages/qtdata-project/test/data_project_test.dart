import 'package:test/test.dart';
import 'package:qtdata_project/qtdata_project.dart';

void main() {
  group('StageType', () {
    test('has 5 stages in order', () {
      expect(StageType.values.length, 5);
      expect(StageType.values[0].label, '需求探索与评估');
      expect(StageType.values[4].label, '验收与交付');
    });
  });

  group('DataProject', () {
    test('required fields', () {
      final project = DataProject(id: 'p1', name: 'demo', title: '演示项目');
      expect(project.name, 'demo');
      expect(project.stages, isEmpty);
    });

    test('with stages', () {
      final stage = ProjectStage(type: StageType.requirementExploration);
      final project = DataProject(
        id: 'p1', name: 'demo', title: '演示',
        stages: [stage],
      );
      expect(project.stages.length, 1);
      expect(project.stages[0].type, StageType.requirementExploration);
    });
  });
}
