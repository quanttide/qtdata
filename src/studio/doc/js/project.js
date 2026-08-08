// ================================================================
//  项目详情页：二维网格、数据蓝图、交付时间线、资料弹窗
// ================================================================
let currentProject = '';

// ===== 渲染二维网格（无灰字、无多余说明文字） =====
function renderMatrix(data) {
    const container = document.getElementById('tlPhaseMatrix');
    if (!data || !data.matrix) {
        container.innerHTML = '<div class="text-sm text-gray-400 p-2">暂无数据</div>';
        return;
    }

    const m = data.matrix;
    const rows = m.rows;
    const cols = m.columns;
    const cells = m.cells;

    let html = `
        <div style="overflow-x:auto;">
            <table class="grid-matrix">
                <thead>
                    <tr>
                        <th style="min-width:60px;border-bottom:2px solid #e2e8f0;">维度 \\ 阶段</th>
            `;
    cols.forEach(col => {
        const st = statusMap[col.status] || statusMap['todo'];
        html += `
                    <th style="border-bottom:2px solid #e2e8f0;">
                        ${col.label}
                        <span class="phase-status-tag ${col.status}" style="display:block;margin-top:2px;">${st.label}</span>
                    </th>
                `;
    });
    html += `
                    </tr>
                </thead>
                <tbody>
            `;

    rows.forEach(row => {
        html += `<tr>`;
        html += `<td class="row-label" style="font-weight:600;text-align:left;padding-left:0.8rem;">${row.label}</td>`;
        cols.forEach(col => {
            const cellKey = row.key + '_' + col.key;
            const cell = cells[cellKey];
            if (cell) {
                const st = statusMap[cell.status] || statusMap['todo'];
                html += `
                    <td class="cell-${cell.status}">
                        <div class="delivery-name">${cell.name}</div>
                        <div style="margin-top:0.2rem;">
                            <span class="status-dot ${cell.status}"></span>
                            <span style="font-size:0.55rem;color:#94a3b8;">${st.label}</span>
                        </div>
                    </td>
                `;
            } else {
                html += `
                    <td class="cell-empty" style="color:#cbd5e1;font-size:0.6rem;">
                        —
                    </td>
                `;
            }
        });
        html += `</tr>`;
    });

    html += `
                </tbody>
            </table>
        </div>
        <div style="display:flex;gap:0.8rem;margin-top:0.5rem;font-size:0.6rem;color:#94a3b8;flex-wrap:wrap;border-top:1px solid #f1f5f9;padding-top:0.5rem;">
            <span><span class="status-dot done" style="display:inline-block;width:6px;height:6px;border-radius:50%;background:#10b981;margin-right:0.2rem;"></span>已完成</span>
            <span><span class="status-dot active" style="display:inline-block;width:6px;height:6px;border-radius:50%;background:#3b82f6;margin-right:0.2rem;"></span>进行中</span>
            <span><span class="status-dot todo" style="display:inline-block;width:6px;height:6px;border-radius:50%;background:#94a3b8;margin-right:0.2rem;"></span>待启动</span>
        </div>
    `;

    container.innerHTML = html;
}

function showTimeline(name) {
    currentProject = name;
    const data = projects[name];
    if (!data) { showToast('项目数据不存在', false); return; }

    document.title = data.name + ' · 量潮数据';
    document.getElementById('tlTitle').textContent = data.name;
    document.getElementById('tlClient').textContent = '客户：' + data.client + ' ｜ 创建于 ' + data.created;
    document.getElementById('tlStatus').textContent = data.status;

    const phaseMap = { '调研': 'research', '谈判': 'negotiate', '实施': 'implement', '验收': 'accept',
        '复盘': 'review' };
    const phaseTag = document.getElementById('tlPhase');
    phaseTag.textContent = data.currentPhase;
    phaseTag.className = 'phase-tag ' + (phaseMap[data.currentPhase] || 'research');

    // 渲染二维网格
    renderMatrix(data);

    // 蓝图
    const bp = data.blueprint;
    if (bp) {
        const stepsContainer = document.getElementById('tlBlueprintSteps');
        if (bp.steps && bp.steps.length > 0) {
            stepsContainer.innerHTML = bp.steps.map((step, idx) => `
                <div class="step-item">
                    <span class="step-num">${idx + 1}</span>
                    <span class="step-text">${step}</span>
                </div>
            `).join('');
        } else {
            stepsContainer.innerHTML = '<div class="text-sm text-gray-400 p-2">暂无处理流程信息</div>';
        }

        const exContainer = document.getElementById('tlBlueprintExceptions');
        if (bp.exceptions && bp.exceptions.length > 0) {
            exContainer.innerHTML = bp.exceptions.map(ex => `
                <div class="exception-item">
                    <span class="ex-label">${ex.label}</span>
                    <span class="ex-strategy">${ex.strategy}</span>
                </div>
            `).join('');
        } else {
            exContainer.innerHTML = '<div class="text-sm text-gray-400 p-2">暂无异常预案</div>';
        }
    }

    // 时间线
    const timeline = document.getElementById('tlTimeline');
    if (data.phases && data.phases.length > 0) {
        timeline.innerHTML = data.phases.map((ph) => {
            const statusMap2 = { done: '已完成', active: '进行中', todo: '待启动' };
            const statusLabel = statusMap2[ph.status] || '待启动';
            const statusCls = ph.status;

            let itemsHtml = '';
            if (ph.items && ph.items.length > 0) {
                itemsHtml = ph.items.map(item => `
                    <div class="tl-deliverable">
                        <span class="dl-icon"><i class="fas fa-file-alt"></i></span>
                        <span><strong>${item.name}</strong> — ${item.desc}</span>
                        ${item.hasDoc ? `<span class="dl-action" onclick="event.stopPropagation();showDoc('${item.name}', '${item.type || '资料'}', '${data.name}')">查看资料</span>` : ''}
                    </div>
                `).join('');
            } else {
                itemsHtml = `<div class="tl-empty"><i class="fas fa-minus-circle mr-1"></i> 暂无交付物</div>`;
            }

            return `
                <div class="timeline-item ${ph.status}">
                    <div class="tl-header">
                        <span class="tl-title">${ph.name}</span>
                        <span class="tl-status ${ph.status}">${statusLabel}</span>
                        ${ph.items && ph.items.length > 0 ? `<span class="text-xs text-gray-400">${ph.items.length} 项</span>` : ''}
                    </div>
                    <div class="tl-deliverables">${itemsHtml}</div>
                </div>
            `;
        }).join('');
    } else {
        timeline.innerHTML = '<div class="text-sm text-gray-400 p-2">暂无时间线数据</div>';
    }
}

function showDoc(name, type, project) {
    document.getElementById('docModalTitle').textContent = name;
    document.getElementById('docModalSub').textContent = project + ' · ' + type;
    const content = document.getElementById('docModalContent');
    let files = [];
    if (name.includes('Assignor')) {
        files = [
            { name: 'TMA_assignor_matched.csv', size: '12.7 MB' },
            { name: 'Assignor_AI审核摘要.pdf', size: '0.8 MB' },
            { name: 'assignor_threshold_log.xlsx', size: '0.3 MB' }
        ];
    } else if (name.includes('Assignee')) {
        files = [
            { name: 'TMA_assignee_matched.csv', size: '8.3 MB' },
            { name: 'assignee_code_package.zip', size: '45.2 MB' },
            { name: 'assignee_progress_log.docx', size: '0.2 MB' }
        ];
    } else if (name.includes('Owner')) {
        files = [
            { name: 'TMC_owner_matched.csv', size: '6.1 MB' },
            { name: 'owner_matching_spec.pdf', size: '0.5 MB' }
        ];
    } else if (name.includes('标准化')) {
        files = [
            { name: 'name_standardization_rules.xlsx', size: '0.4 MB' },
            { name: 'standardized_names_sample.csv', size: '2.1 MB' }
        ];
    } else if (name.includes('合同')) {
        files = [
            { name: '内部客户_合同扫描件.pdf', size: '1.8 MB' },
            { name: '合同签署记录.jpg', size: '0.3 MB' }
        ];
    } else {
        files = [
            { name: name + '.pdf', size: '1.2 MB' },
            { name: name + '_data.csv', size: '0.8 MB' }
        ];
    }
    content.innerHTML = `
        <div class="text-sm text-gray-500 mb-2">以下资料可供下载：</div>
        ${files.map(f => `
            <div class="file-item">
                <i class="fas fa-file-pdf"></i>
                <span>${f.name}</span>
                <span class="text-xs text-gray-400">${f.size}</span>
                <span class="file-action" onclick="showToast('📥 下载 ${f.name}')">下载</span>
            </div>
        `).join('')}
        <div class="text-xs text-gray-400 mt-2 border-t pt-2">
            📊 Assignor 跑数摘要：58,797 条进入 AI 审核 | 5,067 条自动通过（8.6%）| 91.4% 判定无匹配
        </div>
    `;
    document.getElementById('docModal').classList.add('active');
}

document.addEventListener('DOMContentLoaded', function() {
    const params = new URLSearchParams(location.search);
    const name = params.get('name');
    if (!name || !projects[name]) {
        showToast('项目数据不存在，返回列表');
        setTimeout(() => { location.href = 'index.html'; }, 1200);
        return;
    }
    showTimeline(name);
    console.log('✅ 量潮数据云 · V0.1.1 二维网格精简版（项目详情页）已加载');
});
