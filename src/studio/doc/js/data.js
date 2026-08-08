        const statusMap = {
            'done': { label: '已完成', cls: 'done' },
            'active': { label: '进行中', cls: 'active' },
            'todo': { label: '待启动', cls: 'todo' }
        };

        const projects = {
            '量潮科技数字化': {
                name: '量潮科技数字化',
                client: '内部客户',
                created: '2026-01-12',
                status: '进行中',
                currentPhase: '实施',
                contractAmount: 15,
                deliverables: [
                    { name: '交付结果表 A', status: 'done' },
                    { name: '交付结果表 B', status: 'active' },
                    { name: '交付结果表 C', status: 'todo' }
                ],
                matrix: {
                    rows: [
                        { label: '📋 项目', key: 'project' },
                        { label: '📊 数据', key: 'data' },
                        { label: '💼 商务', key: 'business' }
                    ],
                    columns: [
                        { label: '调研', key: 'research', status: 'done' },
                        { label: '谈判', key: 'negotiate', status: 'active' },
                        { label: '实施', key: 'implement', status: 'todo' },
                        { label: '验收', key: 'accept', status: 'todo' },
                        { label: '复盘', key: 'review', status: 'todo' }
                    ],
                    cells: {
                        'project_research': { name: '项目背景确认书', status: 'done' },
                        'project_negotiate': { name: '启动约定确认书', status: 'active' },
                        'project_implement': { name: '进度同步记录', status: 'todo' },
                        'project_accept': { name: '验收确认书', status: 'todo' },
                        'project_review': { name: '复盘报告', status: 'todo' },
                        'data_research': { name: '数据需求确认书', status: 'done' },
                        'data_negotiate': { name: '数据规格书', status: 'active' },
                        'data_implement': { name: '数据清洗与匹配', status: 'todo' },
                        'data_accept': { name: '数据报告', status: 'todo' },
                        'data_review': { name: '异常沉淀', status: 'todo' },
                        'business_research': { name: '报价单', status: 'done' },
                        'business_negotiate': { name: '合同', status: 'active' },
                        'business_implement': { name: '商务变更确认书', status: 'todo' },
                        'business_accept': { name: '交付与收款', status: 'todo' },
                        'business_review': { name: '结算与归档', status: 'todo' }
                    }
                },
                blueprint: {
                    steps: [
                        '加载原始数据 — 加载 TMC owner.dta、TMA assignee.dta、TMA assignor.dta',
                        '业务规则筛选 — 仅保留美国公司、剔除个人申请人、保留原始申请人和注册人',
                        '公司名称标准化 — 统一大小写、符号、常见后缀等（参考客户提供的标准化 do 文件）',
                        '上市公司数据库整合 — 加载 5 个数据源，按优先级排序，将 CIQ ID 映射为 GVKEY',
                        '多级匹配 — 精确匹配优先，模糊匹配使用 模糊匹配算法，计算调整后相似度分数（原始相似度 + 惩罚项）',
                        '阈值分流与 AI 审核 — ≥95% 自动通过，85%~95% 进入人工审核队列，<85% 自动拒绝',
                        '结果回填与输出 — 生成三个匹配结果表（TMC Owner / TMA Assignee / TMA Assignor）及未匹配记录'
                    ],
                    exceptions: [
                        { label: '精确匹配', strategy: '优先自动通过，确保高置信度匹配' },
                        { label: '无候选', strategy: '自动判定为无匹配' },
                        { label: '罗马数字不一致', strategy: '自动拒绝，降低同名不同实体误配风险' },
                        { label: '仅法律后缀差异', strategy: '核心名称一致则自动通过' },
                        { label: '核心名称包含/缩写等', strategy: '进入人工审核，避免误判' }
                    ]
                },
                phases: [{
                    name: '数据预处理与标准化',
                    status: 'done',
                    items: [
                        { name: '客户 原始数据清洗', desc: 'owner/assignee/assignor 三表清洗完成', hasDoc: true,
                            type: '清洗脚本' },
                        { name: '公司名称标准化', desc: '统一大小写、符号、后缀，参考 do 文件', hasDoc: true,
                            type: '标准化规则' },
                        { name: '上市公司数据库整合', desc: '5 个数据源整合为统一匹配字典', hasDoc: true, type: '映射表' }
                    ]
                }, {
                    name: '匹配引擎开发',
                    status: 'active',
                    items: [
                        { name: '精确匹配 + 模糊匹配实现', desc: '模糊匹配算法 算法，调整后分数 = 原始相似度 + 惩罚项',
                            hasDoc: true, type: '匹配代码' },
                        { name: '阈值分流方案', desc: '≥95% 自动通过，85%~95% 人工审核，<85% 自动拒绝', hasDoc: true,
                            type: '方案文档' },
                        { name: 'AI 审核方案', desc: '2026-04-07 客户已同意 AI 审核方案', hasDoc: true, type: '方案文档' }
                    ]
                }, {
                    name: 'Assignor 交付',
                    status: 'done',
                    items: [
                        { name: 'Assignor 初步交付', desc: '2026-02-11 向客户交付成果', hasDoc: true, type: '交付文件' },
                        { name: 'Assignor AI 审核完成', desc: '全部记录完成 AI 审核并自动通过',
                            hasDoc: true, type: '审核报告' },
                        { name: 'Assignor 结果同步客户', desc: '2026-05-09 同步客户，待反馈', hasDoc: true,
                            type: '沟通记录' }
                    ]
                }, {
                    name: 'Assignee 推进中',
                    status: 'active',
                    items: [
                        { name: '代码压缩包', desc: '由 PM 保管，原技术离职时未跑完', hasDoc: true, type: '代码包' },
                        { name: '新技术接手', desc: '团队成员甲 / 团队成员乙 接手推进中', hasDoc: false, type: '' }
                    ]
                }, {
                    name: 'Owner 待启动',
                    status: 'todo',
                    items: [
                        { name: 'Owner 匹配', desc: '费用待确认，等上一阶段结果确认后再推进', hasDoc: false,
                            type: '' }
                    ]
                }]
            }
        };
