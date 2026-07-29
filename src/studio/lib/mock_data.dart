import 'models/project.dart';

final mockProjects = <String, Project>{
  '客户受让人标准化与上市公司匹配': const Project(
    name: '客户受让人标准化与上市公司匹配',
    client: '金融课题组 · 实证研究',
    created: '2026-07-01',
    contractMonths: 1,
    status: '已完成',
    currentPhase: ProjectPhase.review,
    deliveryTarget: [
      DeliveryTarget(
        phase: '数据准备',
        items: [
          DeliveryItem(name: '客户原始数据下载', status: ItemStatus.done, dim: '数据'),
          DeliveryItem(name: '公司名称标准化', status: ItemStatus.done, dim: '数据'),
          DeliveryItem(name: '映射表构建(CRSP等)', status: ItemStatus.done, dim: '数据'),
        ],
      ),
      DeliveryTarget(
        phase: '匹配与审核',
        items: [
          DeliveryItem(name: '多候选模糊匹配', status: ItemStatus.done, dim: '数据'),
          DeliveryItem(name: '规则分流与AI审核', status: ItemStatus.done, dim: '数据'),
          DeliveryItem(name: '回填合并导出', status: ItemStatus.done, dim: '数据'),
        ],
      ),
      DeliveryTarget(
        phase: '交付',
        items: [
          DeliveryItem(name: '正式交付表(124.7MB)', status: ItemStatus.done, dim: '数据'),
          DeliveryItem(name: '详细复核表(334.8MB)', status: ItemStatus.done, dim: '数据'),
        ],
      ),
    ],
    blueprint: Blueprint(
      steps: [
        BlueprintStep('客户 Assignee 原始数据下载/准备：使用 客户 Trademark Assignment Dataset 中的 Assignee 数据。'),
        BlueprintStep('公司名称标准化：清洗 eename 并生成 name_std，统一大小写、符号、常见后缀等。'),
        BlueprintStep('上市公司映射表构建：整合 CRSP、COMPUSTAT、WRDS、CIQ 等来源，生成统一 map.dta。'),
        BlueprintStep('多候选匹配：先精确匹配，再用 n-gram + 模糊匹配算法 做模糊匹配，保留多个候选 (candidate_1 至 candidate_5)。'),
        BlueprintStep('规则分流：按匹配类型、核心词相似度、法律后缀、罗马数字等规则自动通过/拒绝/进入审核。'),
        BlueprintStep('AI 审核：对待审核组进行批量 AI 判断，选择候选编号或判定无匹配。'),
        BlueprintStep('回填与合并导出：将自动处理结果和 AI 审核结果回填明细，生成正式交付表和详细复核表。'),
      ],
      exceptions: [
        BlueprintException(label: '精确匹配优先', strategy: '自动通过，确保高置信度'),
        BlueprintException(label: '无候选', strategy: '自动判定为无匹配'),
        BlueprintException(label: '罗马数字不一致', strategy: '自动拒绝，降低误配风险'),
        BlueprintException(label: '仅法律后缀差异', strategy: '核心名称一致则自动通过'),
        BlueprintException(label: '核心名称包含/缩写等', strategy: '进入 AI / 人工审核，避免误判'),
      ],
    ),
    phases: [
      ProjectPhaseDetail(
        name: '数据准备与标准化',
        status: ItemStatus.done,
        items: [
          PhaseItem(name: '客户原始受让人数据', desc: '从客户商标转让数据集获取Assignee原始数据', type: '原始数据'),
          PhaseItem(name: '公司名称标准化', desc: '统一大小写、符号、常见后缀，生成name_std字段', type: '处理脚本'),
        ],
      ),
      ProjectPhaseDetail(
        name: '映射表构建与多候选匹配',
        status: ItemStatus.done,
        items: [
          PhaseItem(name: '上市公司映射表整合', desc: '整合CRSP/COMPUSTAT/WRDS/CIQ生成统一map.dta', type: '映射表'),
          PhaseItem(name: '多候选模糊匹配', desc: '精确匹配 + n-gram/模糊匹配算法，保留candidate_1至candidate_5', type: '匹配结果'),
        ],
      ),
      ProjectPhaseDetail(
        name: '规则分流、AI审核与最终交付',
        status: ItemStatus.done,
        items: [
          PhaseItem(name: '规则分流与AI审核', desc: '自动通过/拒绝/进入审核，AI批量决策匹配候选编号', type: '审核记录'),
          PhaseItem(name: '导出正式交付表', desc: '124.7MB，面向客户的最终匹配结果表', type: '交付文件'),
          PhaseItem(name: '导出详细复核表', desc: '334.8MB，保留candidate_1至candidate_5，供客户自行筛选', type: '交付文件'),
        ],
      ),
    ],
  ),
};
