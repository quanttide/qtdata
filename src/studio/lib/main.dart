import 'package:flutter/material.dart';
import 'package:quanttide_data/quanttide_data.dart';
import 'package:qtdata_project/qtdata_project.dart' hide Task;
import 'screens/data_screen.dart';

void main() {
  runApp(const _App());
}

class _App extends StatelessWidget {
  const _App();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '量潮数据',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueGrey,
          surface: Colors.white,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage();

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const ProjectBoardScreen(),
      const _DataFlowPage(),
    ];

    return Row(
      children: [
        NavigationRail(
          selectedIndex: _currentIndex,
          onDestinationSelected: (i) => setState(() => _currentIndex = i),
          labelType: NavigationRailLabelType.all,
          destinations: const [
            NavigationRailDestination(
              icon: Icon(Icons.dashboard),
              label: Text('看板'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.query_stats),
              label: Text('数据'),
            ),
          ],
        ),
        const VerticalDivider(width: 1),
        Expanded(child: pages[_currentIndex]),
      ],
    );
  }
}

class MockPipelineRepository implements PipelineRepository {
  @override
  Future<Pipeline> fetch(String id) async => _mockPipeline;
}

const _mockPipeline = Pipeline(
  id: 'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
  name: 'order-data-pipeline',
  title: '数据处理流程',
  tasks: [
    Task(id: 'b1c2d3e4-f5a6-7890-bcde-f12345678901', name: 'import/sales-orders', title: '导入销售订单', status: TaskStatus.completed),
    Task(id: 'c2d3e4f5-a6b7-8901-cdef-123456789012', name: 'cleanse/order-data', title: '清洗订单数据', status: TaskStatus.completed),
    Task(id: 'd3e4f5a6-b7c8-9012-def1-234567890123', name: 'merge/customer-info', title: '合并客户信息', status: TaskStatus.completed),
    Task(id: 'e4f5a6b7-c8d9-0123-ef12-345678901234', name: 'compute/customer-rfm', title: '计算客户RFM', status: TaskStatus.inProgress),
    Task(id: 'f5a6b7c8-d9e0-1234-f123-456789012345', name: 'generate/analysis-report', title: '生成分析报告', status: TaskStatus.pending),
  ],
);

class _DataFlowPage extends StatelessWidget {
  const _DataFlowPage();

  static final _repo = MockPipelineRepository();

  static final _mockDatasets = <Dataset>[
    Dataset(id: 'd1', name: 'sales/orders', title: '销售订单', status: DatasetStatus.ready),
    Dataset(id: 'd2', name: 'clean/orders', title: '已清洗订单', status: DatasetStatus.ready),
    Dataset(id: 'd3', name: 'customer/unified', title: '统一客户', status: DatasetStatus.ready),
    Dataset(id: 'd4', name: 'customer/rfm', title: '客户 RFM', status: DatasetStatus.pending),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text('数据流程'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: DataScreen(
        pipelineId: 'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
        repository: _repo,
        datasets: _mockDatasets,
      ),
    );
  }
}
