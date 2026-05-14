import 'package:flutter/material.dart';
import 'package:qtdata_data/qtdata_data.dart';
import 'package:qtdata_project/qtdata_project.dart';

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

class _DataFlowPage extends StatelessWidget {
  const _DataFlowPage();

  static final _mockFlow = ProcessFlow(
    id: '1',
    name: '数据处理流程',
    stages: [
      ProcessStage(id: 's1', name: '导入销售订单', order: 1, status: ProcessStatus.completed),
      ProcessStage(id: 's2', name: '清洗订单数据', order: 2, status: ProcessStatus.completed),
      ProcessStage(id: 's3', name: '合并客户信息', order: 3, status: ProcessStatus.completed),
      ProcessStage(id: 's4', name: '计算客户RFM', order: 4, status: ProcessStatus.running),
      ProcessStage(id: 's5', name: '生成分析报告', order: 5, status: ProcessStatus.pending),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text('数据流程'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: Center(
        child: ProcessFlowScreen(flow: _mockFlow),
      ),
    );
  }
}
