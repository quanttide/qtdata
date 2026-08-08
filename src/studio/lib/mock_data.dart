import 'models/project.dart';

final mockProjects = <String, Project>{
  '量潮科技数字化': const Project(
    name: '量潮科技数字化',
    client: '内部客户',
    created: '2026-01-12',
    updated: '2026-07-28',
    status: '进行中',
    currentPhase: ProjectPhase.implement,
    contractAmount: 15,
    deliverables: [
      Deliverable(name: '交付结果表 A', status: ItemStatus.done),
      Deliverable(name: '交付结果表 B', status: ItemStatus.active),
      Deliverable(name: '交付结果表 C', status: ItemStatus.todo),
    ],
    matrix: ProjectMatrix(
      rows: [
        MatrixRow(label: '📋 项目', key: 'project'),
        MatrixRow(label: '📊 数据', key: 'data'),
        MatrixRow(label: '💼 商务', key: 'business'),
      ],
      columns: [
        MatrixColumn(label: '调研', key: 'research', status: ItemStatus.done),
        MatrixColumn(label: '谈判', key: 'negotiate', status: ItemStatus.active),
        MatrixColumn(label: '实施', key: 'implement', status: ItemStatus.todo),
        MatrixColumn(label: '验收', key: 'accept', status: ItemStatus.todo),
        MatrixColumn(label: '复盘', key: 'review', status: ItemStatus.todo),
      ],
      cells: {
        'project_research': MatrixCell(
          name: '项目背景确认书',
          status: ItemStatus.done,
        ),
        'project_negotiate': MatrixCell(
          name: '启动约定确认书',
          status: ItemStatus.active,
        ),
        'project_implement': MatrixCell(
          name: '进度同步记录',
          status: ItemStatus.todo,
        ),
        'project_accept': MatrixCell(name: '验收确认书', status: ItemStatus.todo),
        'project_review': MatrixCell(name: '复盘报告', status: ItemStatus.todo),
        'data_research': MatrixCell(name: '数据需求确认书', status: ItemStatus.done),
        'data_negotiate': MatrixCell(name: '数据规格书', status: ItemStatus.active),
        'data_implement': MatrixCell(name: '数据清洗与匹配', status: ItemStatus.todo),
        'data_accept': MatrixCell(name: '数据报告', status: ItemStatus.todo),
        'data_review': MatrixCell(name: '异常沉淀', status: ItemStatus.todo),
        'business_research': MatrixCell(name: '报价单', status: ItemStatus.done),
        'business_negotiate': MatrixCell(name: '合同', status: ItemStatus.active),
        'business_implement': MatrixCell(
          name: '商务变更确认书',
          status: ItemStatus.todo,
        ),
        'business_accept': MatrixCell(name: '交付与收款', status: ItemStatus.todo),
        'business_review': MatrixCell(name: '结算与归档', status: ItemStatus.todo),
      },
    ),
    blueprint: Blueprint(
      steps: [
        BlueprintStep(
          '加载原始数据 — 加载 TMC owner.dta、TMA assignee.dta、TMA assignor.dta',
        ),
        BlueprintStep('业务规则筛选 — 仅保留美国公司、剔除个人申请人、保留原始申请人和注册人'),
        BlueprintStep('公司名称标准化 — 统一大小写、符号、常见后缀等（参考客户提供的标准化 do 文件）'),
        BlueprintStep('上市公司数据库整合 — 加载 5 个数据源，按优先级排序，将 CIQ ID 映射为 GVKEY'),
        BlueprintStep('多级匹配 — 精确匹配优先，模糊匹配使用 模糊匹配算法，计算调整后相似度分数（原始相似度 + 惩罚项）'),
        BlueprintStep('阈值分流与 AI 审核 — ≥95% 自动通过，85%~95% 进入人工审核队列，<85% 自动拒绝'),
        BlueprintStep(
          '结果回填与输出 — 生成三个匹配结果表（TMC Owner / TMA Assignee / TMA Assignor）及未匹配记录',
        ),
      ],
      exceptions: [
        BlueprintException(label: '精确匹配', strategy: '优先自动通过，确保高置信度匹配'),
        BlueprintException(label: '无候选', strategy: '自动判定为无匹配'),
        BlueprintException(label: '罗马数字不一致', strategy: '自动拒绝，降低同名不同实体误配风险'),
        BlueprintException(label: '仅法律后缀差异', strategy: '核心名称一致则自动通过'),
        BlueprintException(label: '核心名称包含/缩写等', strategy: '进入人工审核，避免误判'),
      ],
    ),
    phases: [
      ProjectPhaseDetail(
        name: '数据预处理与标准化',
        status: ItemStatus.done,
        items: [
          PhaseItem(
            name: '客户 原始数据清洗',
            desc: 'owner/assignee/assignor 三表清洗完成',
            hasDoc: true,
            type: '清洗脚本',
          ),
          PhaseItem(
            name: '公司名称标准化',
            desc: '统一大小写、符号、后缀，参考 do 文件',
            hasDoc: true,
            type: '标准化规则',
          ),
          PhaseItem(
            name: '上市公司数据库整合',
            desc: '5 个数据源整合为统一匹配字典',
            hasDoc: true,
            type: '映射表',
          ),
        ],
      ),
      ProjectPhaseDetail(
        name: '匹配引擎开发',
        status: ItemStatus.active,
        items: [
          PhaseItem(
            name: '精确匹配 + 模糊匹配实现',
            desc: '模糊匹配算法 算法，调整后分数 = 原始相似度 + 惩罚项',
            hasDoc: true,
            type: '匹配代码',
          ),
          PhaseItem(
            name: '阈值分流方案',
            desc: '≥95% 自动通过，85%~95% 人工审核，<85% 自动拒绝',
            hasDoc: true,
            type: '方案文档',
          ),
          PhaseItem(
            name: 'AI 审核方案',
            desc: '2026-04-07 客户已同意 AI 审核方案',
            hasDoc: true,
            type: '方案文档',
          ),
        ],
      ),
      ProjectPhaseDetail(
        name: 'Assignor 交付',
        status: ItemStatus.done,
        items: [
          PhaseItem(
            name: 'Assignor 初步交付',
            desc: '2026-02-11 向客户交付成果',
            hasDoc: true,
            type: '交付文件',
          ),
          PhaseItem(
            name: 'Assignor AI 审核完成',
            desc: '全部记录完成 AI 审核并自动通过',
            hasDoc: true,
            type: '审核报告',
          ),
          PhaseItem(
            name: 'Assignor 结果同步客户',
            desc: '2026-05-09 同步客户，待反馈',
            hasDoc: true,
            type: '沟通记录',
          ),
        ],
      ),
      ProjectPhaseDetail(
        name: 'Assignee 推进中',
        status: ItemStatus.active,
        items: [
          PhaseItem(
            name: '代码压缩包',
            desc: '由 PM 保管，原技术离职时未跑完',
            hasDoc: true,
            type: '代码包',
          ),
          PhaseItem(
            name: '新技术接手',
            desc: '团队成员甲 / 团队成员乙 接手推进中',
            hasDoc: false,
            type: '',
          ),
        ],
      ),
      ProjectPhaseDetail(
        name: 'Owner 待启动',
        status: ItemStatus.todo,
        items: [
          PhaseItem(
            name: 'Owner 匹配',
            desc: '费用待确认，等上一阶段结果确认后再推进',
            hasDoc: false,
            type: '',
          ),
        ],
      ),
    ],
  ),
};
