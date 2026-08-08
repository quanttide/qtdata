import 'models/project.dart';

final mockProjects = <String, Project>{
  // 内部定价估算（量潮科技数字化 · 议事决议数据需求点）：
  // 成本法：5 阶段（采集0.5/建模1.0/导入1.5/治理1.0/报告1.0 人天） × 1000元/人天 ≈ 0.5 万元
  // 市场法：外部类似内部运营数据处理服务行情 ≈ 1.2 万元
  // 内部价 = 市场价 × 7折 ≈ 0.8 万元（成本 1.6 倍，事业部核算有空间）
  '量潮科技数字化': const Project(
    name: '量潮科技数字化',
    client: '量潮科技（内部项目）',
    created: '2026-08-01',
    updated: '2026-08-08',
    status: '进行中',
    currentPhase: ProjectPhase.implement,
    contractAmount: 0.8,
    deliverables: [
      Deliverable(name: '议事决议数据 — 决议档案（第33周示例）', status: ItemStatus.done),
      Deliverable(name: '议事决议数据 — 治理视图', status: ItemStatus.done),
      Deliverable(name: '议事决议数据 — 周会决议汇总', status: ItemStatus.done),
      Deliverable(name: '议事决议数据 — 历史周会批量整理', status: ItemStatus.active),
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
          name: '数据需求文档（DRD）',
          status: ItemStatus.done,
        ),
        'project_negotiate': MatrixCell(
          name: '数据规格评审',
          status: ItemStatus.active,
        ),
        'project_implement': MatrixCell(
          name: '周会进度同步',
          status: ItemStatus.todo,
        ),
        'project_accept': MatrixCell(name: '治理视图验收', status: ItemStatus.done),
        'project_review': MatrixCell(name: '复盘报告', status: ItemStatus.todo),
        'data_research': MatrixCell(name: '飞书议事数据盘点', status: ItemStatus.done),
        'data_negotiate': MatrixCell(
          name: '数据规格书（数据契约）',
          status: ItemStatus.done,
        ),
        'data_implement': MatrixCell(
          name: '决议提取与标准化',
          status: ItemStatus.done,
        ),
        'data_accept': MatrixCell(name: '决议档案落库', status: ItemStatus.done),
        'data_review': MatrixCell(name: '质量基线校验', status: ItemStatus.done),
        'business_research': MatrixCell(
          name: '需求范围确认（内部）',
          status: ItemStatus.done,
        ),
        'business_negotiate': MatrixCell(
          name: '数据源接入（飞书）',
          status: ItemStatus.active,
        ),
        'business_implement': MatrixCell(
          name: '数据源接入配置',
          status: ItemStatus.todo,
        ),
        'business_accept': MatrixCell(
          name: '数据交付（治理视图）',
          status: ItemStatus.todo,
        ),
        'business_review': MatrixCell(name: '归档', status: ItemStatus.todo),
      },
    ),
    blueprint: Blueprint(
      steps: [
        BlueprintStep('采集原始数据 — 飞书议事档案导出（lark-cli drive +export：提案/会议纪要/简报）'),
        BlueprintStep('解析文档结构 — 提取编号、提案人、poll 标记、议程结构'),
        BlueprintStep('决议标准化 — 对齐决议 schema（id/title/owner/due/status/溯源）'),
        BlueprintStep('纪要决议提取 — 从议程中提取决定类记录（决定/通过/落实/确定）'),
        BlueprintStep('档案落库 — 一决议一文件（YAML），索引聚合'),
        BlueprintStep('治理输出 — 逾期推导、责任人分布、治理视图 JSON'),
        BlueprintStep('周会报告 — 生成周会决议汇总与质量指标（编号错位/辩论记录/决议落档）'),
      ],
      exceptions: [
        BlueprintException(label: '无责任人', strategy: '标记"未指定"，治理视图提示补全——创建决议时 owner 必填'),
        BlueprintException(label: '无完成期限', strategy: '逾期推导跳过，不误报——期限缺失本身是治理信号'),
        BlueprintException(label: '编号双轨', strategy: '提案按发布周、会议按召开周编号，跨文档错位检测（错位率 100%）'),
        BlueprintException(label: '纪要无决议记录', strategy: '标记表决-决议断链，提示表决引擎/决议归档缺失'),
      ],
    ),
    phases: [
      ProjectPhaseDetail(
        name: '数据采集',
        status: ItemStatus.done,
        items: [
          PhaseItem(
            name: '飞书议事档案盘点',
            desc: '议事档案知识库：议题（12 类）、决议、执行管理节点',
            hasDoc: true,
            type: '盘点清单',
          ),
          PhaseItem(
            name: '数据导出',
            desc: 'lark-cli drive +export：提案 5 篇、会议纪要、部门简报',
            hasDoc: true,
            type: '导出脚本',
          ),
        ],
      ),
      ProjectPhaseDetail(
        name: '数据建模',
        status: ItemStatus.done,
        items: [
          PhaseItem(
            name: '决议 schema 定义',
            desc: 'id/title/content/owner/due/status/vote/source/evidence/history',
            hasDoc: true,
            type: '数据契约',
          ),
          PhaseItem(
            name: '领域模型',
            desc: '议题（提案是一类议题）、决议（独立管理）、议程（纪要=议程记录形态）',
            hasDoc: true,
            type: '领域模型文档',
          ),
        ],
      ),
      ProjectPhaseDetail(
        name: '数据导入',
        status: ItemStatus.done,
        items: [
          PhaseItem(
            name: '提案解析',
            desc: '5 篇提案 → 决议候选（编号/提案人/poll）',
            hasDoc: true,
            type: '导入脚本',
          ),
          PhaseItem(
            name: '纪要决议提取',
            desc: '从议程提取决定类记录，共导入 8 条决议',
            hasDoc: true,
            type: '导入脚本',
          ),
          PhaseItem(
            name: '决议档案生成（第33周示例）',
            desc: '一决议一文件（YAML），对齐 schema，示例已上线',
            hasDoc: true,
            type: '决议档案',
          ),
        ],
      ),
      ProjectPhaseDetail(
        name: '治理输出',
        status: ItemStatus.done,
        items: [
          PhaseItem(
            name: '索引与逾期推导',
            desc: 'index.yaml 聚合统计，逾期 = due < today 且未完成',
            hasDoc: true,
            type: '治理脚本',
          ),
          PhaseItem(
            name: '治理视图 JSON',
            desc: 'stats/overdue/by_owner/resolutions——客户端可消费',
            hasDoc: true,
            type: '数据交付物',
          ),
        ],
      ),
      ProjectPhaseDetail(
        name: '周会报告',
        status: ItemStatus.done,
        items: [
          PhaseItem(
            name: '周会决议汇总',
            desc: '决议清单 + 质量指标（编号错位/辩论记录/决议落档）',
            hasDoc: true,
            type: '报告',
          ),
          PhaseItem(
            name: '质量基线',
            desc: '8 项实验基线：编号错位 100%、辩论记录 20%、决议落档 0 条',
            hasDoc: true,
            type: '基线报告',
          ),
        ],
      ),
      ProjectPhaseDetail(
        name: '历史周会批量整理',
        status: ItemStatus.active,
        items: [
          PhaseItem(
            name: '历史周会导出',
            desc: '第 30/31/32 周等历史纪要批量导出（lark-cli）',
            hasDoc: false,
            type: '',
          ),
          PhaseItem(
            name: '流水线批量跑通',
            desc: '复用导入/治理流水线批量处理 + 质检（编号/决议质量）',
            hasDoc: false,
            type: '',
          ),
          PhaseItem(
            name: '结果核对与归档',
            desc: '人工核对 + 飞书知识库回写',
            hasDoc: false,
            type: '',
          ),
        ],
      ),
    ],
  ),
};
