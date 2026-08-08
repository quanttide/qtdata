// ================================================================
//  首页（我的项目）：统计卡片、筛选与项目列表
// ================================================================
let filter = 'all';

function filterProjects(f, el, btn) {
    filter = f;
    document.querySelectorAll('.stat-card').forEach(c => c.classList.remove('active-filter'));
    if (el) el.classList.add('active-filter');
    document.querySelectorAll('.filter-group button').forEach(b => b.classList.remove('active'));
    document.querySelectorAll('.filter-group button').forEach(b => {
        const map = { 'all': '全部', 'active': '进行中', 'done': '已完成', 'pending': '待启动' };
        if (b.textContent.trim() === map[f]) b.classList.add('active');
    });
    const cards = document.querySelectorAll('#projectList .project-card');
    let count = 0;
    cards.forEach(card => {
        const badge = card.querySelector('.status-badge');
        let s = 'all';
        if (badge) {
            const t = badge.textContent.trim();
            if (t === '进行中') s = 'active';
            else if (t === '已完成') s = 'done';
            else if (t === '待启动') s = 'pending';
        }
        const match = f === 'all' || s === f;
        card.style.display = match ? '' : 'none';
        if (match) count++;
    });
    document.getElementById('projectCount').textContent = count + ' 个项目';
}

function countDeliverableStatus(deliverables) {
    const counts = { done: 0, active: 0, todo: 0 };
    if (!deliverables) return counts;
    deliverables.forEach(d => {
        if (d.status === 'done') counts.done++;
        else if (d.status === 'active') counts.active++;
        else counts.todo++;
    });
    return counts;
}

function renderProjects() {
    const container = document.getElementById('projectList');
    container.innerHTML = '';
    Object.keys(projects).forEach(key => {
        const p = projects[key];
        const statusCls = p.status === '已完成' ? 'done' : (p.status === '进行中' ? 'active' : 'pending');
        const phaseMap = { '调研': 'research', '谈判': 'negotiate', '实施': 'implement', '验收': 'accept',
            '复盘': 'review' };
        const phaseCls = phaseMap[p.currentPhase] || 'research';

        const counts = countDeliverableStatus(p.deliverables);
        const total = counts.done + counts.active + counts.todo;
        const progress = total > 0 ? Math.round((counts.done / total) * 100) : 0;
        const confirmedIncome = p.contractAmount ? (p.contractAmount * (counts.done / total)) : 0;

        const card = document.createElement('div');
        card.className = 'project-card';
        card.addEventListener('click', () => {
            location.href = 'project.html?name=' + encodeURIComponent(key);
        });
        card.innerHTML = `
            <div class="flex flex-wrap items-start justify-between gap-2">
                <div class="flex-1 min-w-0">
                    <div class="flex items-center gap-2 flex-wrap">
                        <span class="font-semibold text-gray-800">${p.name}</span>
                        <span class="status-badge ${statusCls}">${p.status}</span>
                        <span class="phase-tag ${phaseCls}">${p.currentPhase}阶段</span>
                    </div>
                    <div class="mt-2 space-y-1.5">
                        <div class="deliverable-dashboard">
                            <span class="dash-item done"><span class="dash-num">${counts.done}</span> 已完成</span>
                            <span class="dash-item active"><span class="dash-num">${counts.active}</span> 进行中</span>
                            <span class="dash-item todo"><span class="dash-num">${counts.todo}</span> 待启动</span>
                            <span class="text-xs text-gray-400 ml-1">共 ${total} 项</span>
                        </div>
                        <div class="progress-value-row">
                            <div class="progress-wrap">
                                <div class="flex items-center justify-between text-xs text-gray-500">
                                    <span>交付完成度</span>
                                    <span class="font-semibold text-gray-700">${progress}%</span>
                                </div>
                                <div class="progress-bar">
                                    <div class="progress-fill" style="width:${progress}%"></div>
                                </div>
                            </div>
                            <span class="value-metric">
                                💰 <span class="amount">${confirmedIncome.toFixed(1)}</span> <span class="total">/ ${p.contractAmount.toFixed(1)} 万元</span>
                            </span>
                        </div>
                    </div>
                </div>
                <div class="text-xs text-gray-400 flex-shrink-0">更新于 2026-07-28</div>
            </div>
        `;
        container.appendChild(card);
    });
    filterProjects('all', document.querySelector('.stat-card'));
}

document.addEventListener('DOMContentLoaded', function() {
    renderProjects();
    console.log('✅ 量潮数据云 · V0.1.1 二维网格精简版（首页）已加载');
});
