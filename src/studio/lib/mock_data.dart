import 'package:quanttide_data/quanttide_data.dart';

class MockPipelineRepository implements PipelineRepository {
  @override
  Future<Pipeline> fetch(String id) async => _mockPipeline;
}

const _mockPipeline = Pipeline(
  id: 'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
  name: 'factory-output-pipeline',
  title: '工厂产量数据分析',
  tasks: [
    Task(id: 't1', name: 'import-raw-output', title: '导入原始产量数据', status: TaskStatus.completed),
    Task(id: 't2', name: 'cleanse-output-data', title: '清洗产量数据', status: TaskStatus.completed),
    Task(id: 't3', name: 'merge-output-records', title: '合并产量记录', status: TaskStatus.completed),
    Task(id: 't4', name: 'compute-output-kpi', title: '计算产量KPI', status: TaskStatus.inProgress),
    Task(id: 't5', name: 'generate-analysis-report', title: '生成分析报告', status: TaskStatus.pending),
  ],
);

final mockDatasets = <Dataset>[
  Dataset(id: 'd1', name: 'raw-output-data', title: '原始产量数据', status: DatasetStatus.pending),
  Dataset(id: 'd2', name: 'cleaned-output-data', title: '已清洗产量数据', status: DatasetStatus.ready),
  Dataset(id: 'd3', name: 'merged-output-records', title: '合并后产量记录', status: DatasetStatus.ready),
  Dataset(id: 'd4', name: 'output-analysis-results', title: '产量分析结果', status: DatasetStatus.ready),
];
