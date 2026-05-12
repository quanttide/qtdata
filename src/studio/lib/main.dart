import 'package:flutter/material.dart';
import 'package:qtdata_project/qtdata_project.dart';

void main() {
  runApp(const QtDataStudio());
}

class QtDataStudio extends StatelessWidget {
  const QtDataStudio({super.key});

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
      home: DataBoardScreen(board: _demoBoard()),
    );
  }

  DataBoard _demoBoard() {
    return DataBoard(tasks: [
      Task(id: 'r1', title: '客户数据清洗需求', description: '客户需要清洗近3年销售数据', type: 'requirement', status: 'pending'),
      Task(id: 'r2', title: '电商数据分析需求', description: '分析用户购买行为和商品关联', type: 'requirement', status: 'confirmed'),
      Task(id: 'a1', title: '签订数据处理协议', description: '明确数据范围、交付标准、验收条件', type: 'agreement'),
      Task(id: 'e1', title: '数据清洗与预处理', description: '', type: 'execution', status: 'doing'),
      Task(id: 'c1', title: '新增字段格式调整', description: '客户要求增加时间戳字段', type: 'change', status: 'pending'),
    ]);
  }
}
