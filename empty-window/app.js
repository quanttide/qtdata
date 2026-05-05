const fields = {
  projectName: document.querySelector("#projectName"),
  clientType: document.querySelector("#clientType"),
  complexity: document.querySelector("#complexity"),
  businessValue: document.querySelector("#businessValue"),
  budget: document.querySelector("#budget"),
  deadline: document.querySelector("#deadline"),
  quoteSpeed: document.querySelector("#quoteSpeed"),
};

const outputs = {
  complexityValue: document.querySelector("#complexityValue"),
  valueValue: document.querySelector("#valueValue"),
  heroOpportunity: document.querySelector("#heroOpportunity"),
  heroBudget: document.querySelector("#heroBudget"),
  heroDays: document.querySelector("#heroDays"),
  heroRisk: document.querySelector("#heroRisk"),
  heroAdvice: document.querySelector("#heroAdvice"),
  scoreRing: document.querySelector("#scoreRing"),
  scoreValue: document.querySelector("#scoreValue"),
  recommendation: document.querySelector("#recommendation"),
  summary: document.querySelector("#summary"),
  quoteRange: document.querySelector("#quoteRange"),
  deliveryPressure: document.querySelector("#deliveryPressure"),
  cognitiveLoad: document.querySelector("#cognitiveLoad"),
  acceptanceRisk: document.querySelector("#acceptanceRisk"),
  timelineList: document.querySelector("#timelineList"),
};

const clientProfiles = {
  startup: {
    name: "创业公司",
    riskWeight: 0.88,
    budgetFlex: 0.86,
    acceptance: "低到中",
    note: "更适合做最小可行版本，用一两个核心指标快速验证方向。",
  },
  sme: {
    name: "中小企业",
    riskWeight: 1,
    budgetFlex: 1,
    acceptance: "中",
    note: "适合把降本增效目标转成可量化指标，先解决最痛的一段流程。",
  },
  enterprise: {
    name: "大型企业",
    riskWeight: 1.18,
    budgetFlex: 1.28,
    acceptance: "高",
    note: "需要提前明确权限、数据口径、验收标准和跨部门协作边界。",
  },
};

const speedProfiles = {
  slow: { label: "稳健", factor: 1.06, clarity: 10, text: "先用访谈和资料确认边界，再给正式报价。" },
  balanced: { label: "平衡", factor: 1, clarity: 4, text: "当天给方向，随后补齐关键问题和报价区间。" },
  fast: { label: "快速", factor: 0.94, clarity: -4, text: "先给客户一个范围感，适合抢占沟通窗口。" },
};

function clamp(value, min, max) {
  return Math.min(Math.max(value, min), max);
}

function formatCurrency(value) {
  return new Intl.NumberFormat("zh-CN", {
    style: "currency",
    currency: "CNY",
    maximumFractionDigits: 0,
  }).format(value);
}

function levelByScore(score) {
  if (score >= 82) return { risk: "低", advice: "优先接单", color: "#16a34a" };
  if (score >= 68) return { risk: "中", advice: "拆分后接单", color: "#2563eb" };
  if (score >= 52) return { risk: "中高", advice: "谨慎评估", color: "#f59e0b" };
  return { risk: "高", advice: "建议暂缓", color: "#ef4444" };
}

function pressureLabel(value) {
  if (value >= 80) return "很高";
  if (value >= 62) return "中高";
  if (value >= 42) return "中";
  return "低";
}

function buildTimeline({ profile, speed, score, quoteLow, quoteHigh, complexity, value, deadline }) {
  const scopeAction = complexity > 7
    ? "把需求拆成一期核心功能和二期扩展功能，避免客户一上来就承担过高成本。"
    : "保持当前范围，但把核心指标、数据来源和验收口径写清楚。";

  const decisionAction = score >= 68
    ? `建议接单，报价区间为 ${formatCurrency(quoteLow)} - ${formatCurrency(quoteHigh)}。`
    : "建议先做 1 次付费诊断或需求澄清，不要直接承诺完整交付。";

  const deliveryAction = deadline < complexity * 4
    ? "交付上采用周节奏验收，每周给客户可见成果，降低临近验收时的争议。"
    : "交付节奏相对健康，可以安排原型确认、开发联调、试运行和验收复盘。";

  return [
    `副官先问清楚客户目标：${profile.note}`,
    `${speed.text} 这样客户能快速知道这个 story 对不对。`,
    scopeAction,
    decisionAction,
    deliveryAction,
    `验收时展示价值结果：业务价值 ${value}/10、复杂度 ${complexity}/10、建议周期 ${Math.max(14, complexity * 5)} 天。`,
  ];
}

function simulate() {
  const projectName = fields.projectName.value.trim() || "未命名项目";
  const profile = clientProfiles[fields.clientType.value];
  const speed = speedProfiles[fields.quoteSpeed.value];
  const complexity = Number(fields.complexity.value);
  const value = Number(fields.businessValue.value);
  const budget = Number(fields.budget.value) || 0;
  const deadline = Number(fields.deadline.value) || 1;

  const estimatedCost = (complexity * 9500 + value * 4200 + 12000) * profile.budgetFlex * speed.factor;
  const budgetFit = clamp((budget / estimatedCost) * 32, 0, 32);
  const valueScore = value * 6;
  const complexityPenalty = complexity * 3.2 * profile.riskWeight;
  const deadlinePressure = clamp((complexity * 5 - deadline) * 1.8, 0, 24);
  const clarityBonus = speed.clarity;
  const score = Math.round(clamp(46 + valueScore + budgetFit + clarityBonus - complexityPenalty - deadlinePressure, 0, 100));
  const level = levelByScore(score);

  const pressure = clamp(complexity * 8 + Math.max(0, complexity * 5 - deadline) * 2 + (fields.clientType.value === "enterprise" ? 14 : 0), 0, 100);
  const cognitive = clamp(complexity * 7 + (value < 5 ? 12 : 0) + (fields.quoteSpeed.value === "fast" ? 10 : 0), 0, 100);
  const quoteLow = Math.round(estimatedCost * 0.9 / 1000) * 1000;
  const quoteHigh = Math.round(estimatedCost * 1.2 / 1000) * 1000;

  outputs.complexityValue.textContent = complexity;
  outputs.valueValue.textContent = value;
  outputs.heroOpportunity.textContent = projectName;
  outputs.heroBudget.textContent = formatCurrency(budget);
  outputs.heroDays.textContent = `${deadline} 天`;
  outputs.heroRisk.textContent = level.risk;
  outputs.heroAdvice.textContent = level.advice;
  outputs.scoreValue.textContent = score;
  outputs.scoreRing.style.background = `conic-gradient(${level.color} ${score}%, #e5e7eb 0)`;
  outputs.recommendation.textContent = level.advice === "优先接单" ? "建议优先推进并快速报价" : `建议${level.advice}`;
  outputs.summary.textContent = `${profile.name}客户的核心问题不是技术细节，而是这个需求值不值得投。当前投资价值 ${score} 分，${level.advice}；建议用“需求卡片 + 副官建议 + 验收复盘”的方式降低认知负担。`;
  outputs.quoteRange.textContent = `${formatCurrency(quoteLow)} - ${formatCurrency(quoteHigh)}`;
  outputs.deliveryPressure.textContent = pressureLabel(pressure);
  outputs.cognitiveLoad.textContent = pressureLabel(cognitive);
  outputs.acceptanceRisk.textContent = profile.acceptance;

  outputs.timelineList.replaceChildren(
    ...buildTimeline({ profile, speed, score, quoteLow, quoteHigh, complexity, value, deadline }).map((item) => {
      const li = document.createElement("li");
      li.textContent = item;
      return li;
    })
  );
}

Object.values(fields).forEach((field) => {
  field.addEventListener("input", simulate);
  field.addEventListener("change", simulate);
});

document.querySelector("#simulateBtn").addEventListener("click", simulate);

simulate();
