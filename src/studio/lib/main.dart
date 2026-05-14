import 'package:flutter/material.dart';
import 'package:qtdata_project/qtdata_project.dart' hide Task;
import 'mock_data.dart';
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
  const HomePage({super.key});

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

  static final _repo = MockPipelineRepository();

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
        datasets: mockDatasets,
      ),
    );
  }
}
