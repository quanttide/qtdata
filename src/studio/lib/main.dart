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
      // 需求探索
      Task(id: 'r1', title: '客户数据清洗需求', description: '客户需要清洗近3年销售数据，包含订单、客户、产品三张表，预计数据量约500万行', type: 'requirement', status: 'pending'),
      Task(id: 'r2', title: '电商平台用户行为分析', description: '分析用户浏览→加购→下单转化路径，识别流失节点，输出优化建议报告', type: 'requirement', status: 'confirmed'),
      Task(id: 'r3', title: '库存预测模型需求', description: '基于历史销售数据构建库存预测模型，降低缺货率，减少库存积压', type: 'requirement', status: 'pending'),
      Task(id: 'r4', title: '变更：新增数据源字段', description: '客户在清洗过程中发现需要额外合并CRM系统中的客户等级字段', type: 'requirement', status: 'pending'),
      Task(id: 'r5', title: '变更：调整交付格式', description: '客户要求最终交付格式从CSV改为Parquet，需评估对处理流程的影响', type: 'requirement', status: 'confirmed'),
      // 约定启动
      Task(id: 'a1', title: '签订数据处理协议', description: '明确数据范围、交付标准、验收条件、付款节点、保密条款', type: 'agreement'),
      Task(id: 'a2', title: '数据安全与保密协议', description: '客户数据涉及商业机密，需签署NDA并约定数据销毁流程', type: 'agreement'),
      Task(id: 'a3', title: '内部资源分配', description: '组建项目团队：数据工程师2人、分析师1人、项目经理1人', type: 'agreement'),
      // 执行监控
      Task(id: 'e1', title: '数据探查与质量评估', description: '对客户提供的样本数据进行完整性、一致性、准确性评估，输出数据质量报告', type: 'execution', status: 'doing'),
      Task(id: 'e2', title: '数据清洗ETL开发', description: '开发数据清洗pipeline：去重、缺失值处理、异常值检测、字段标准化', type: 'execution', status: 'doing'),
      Task(id: 'e3', title: '分析模型开发', description: '基于清洗后的数据构建用户行为分析模型，完成特征工程和模型训练', type: 'execution', status: 'todo'),
      Task(id: 'e4', title: '每周进度同步', description: '向客户汇报本周完成量、下周计划、风险预警', type: 'execution', status: 'doing'),
      // 验收交付
      Task(id: 'c1', title: '交付物验证', description: '客户对清洗后的数据进行抽样验证，确认数据质量符合约定标准', type: 'acceptance', status: 'pending'),
      Task(id: 'c2', title: '最终报告提交', description: '提交完整的数据清洗报告、分析报告、模型说明文档及数据文件', type: 'acceptance', status: 'pending'),
      Task(id: 'c3', title: '尾款结算与项目关闭', description: '客户确认验收后支付尾款，项目资料归档，数据按约定销毁或移交', type: 'acceptance', status: 'pending'),
    ]);
  }
}
