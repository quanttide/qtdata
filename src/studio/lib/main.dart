import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qtdata_project/qtdata_project.dart';

void main() {
  runApp(const QtDataStudio());
}

class QtDataStudio extends StatelessWidget {
  final ApiClient? apiClient;

  const QtDataStudio({super.key, this.apiClient});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DataBoardState(api: apiClient ?? ApiClient())..load(),
      child: _App(),
    );
  }
}

class _App extends StatelessWidget {
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
      home: Consumer<DataBoardState>(
        builder: (context, state, _) {
          if (state.loading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (state.error != null) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('加载失败: ${state.error}'),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () => context.read<DataBoardState>().load(),
                      child: const Text('重试'),
                    ),
                  ],
                ),
              ),
            );
          }
          return DataBoardScreen(board: state.board);
        },
      ),
    );
  }
}
