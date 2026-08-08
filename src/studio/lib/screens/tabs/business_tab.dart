import 'package:flutter/material.dart';

import '../../models/project.dart';
import '../../widgets/common/section_header.dart';
import '../../widgets/common/status_badge.dart';

/// 商务：报价 → 合同 → 交付 → 结款
class BusinessTab extends StatelessWidget {
  final Project project;

  const BusinessTab({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final business = project.business;
    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        _QuotationCard(business: business),
        const SizedBox(height: 16),
        _ContractCard(project: project, business: business),
        const SizedBox(height: 16),
        _DeliveryCard(project: project),
        const SizedBox(height: 16),
        _PaymentCard(business: business),
        const SizedBox(height: 16),
        _BusinessFlowCard(matrix: project.matrix),
      ],
    );
  }
}

/// 卡片外壳
class _BusinessCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget child;

  const _BusinessCard({
    required this.icon,
    required this.title,
    this.subtitle = '',
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(icon: icon, title: title, subtitle: subtitle),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

/// 报价：成本法 / 市场法 / 内部价
class _QuotationCard extends StatelessWidget {
  final BusinessInfo? business;

  const _QuotationCard({required this.business});

  @override
  Widget build(BuildContext context) {
    final b = business;
    final items = [
      ('成本法', b?.costBased ?? 0),
      ('市场法', b?.marketBased ?? 0),
      ('内部价', b == null ? 0 : b.costBased * 1.6),
    ];
    return _BusinessCard(
      icon: Icons.request_quote_outlined,
      title: '报价',
      subtitle: '| 定价依据',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: items
                .map(
                  (it) => Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Text(
                            it.$1,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${it.$2.toStringAsFixed(1)} 万',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          if ((b?.pricingNote ?? '').isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              b!.pricingNote,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF94A3B8),
                height: 1.6,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// 合同：金额 / 签订日期
class _ContractCard extends StatelessWidget {
  final Project project;
  final BusinessInfo? business;

  const _ContractCard({required this.project, required this.business});

  @override
  Widget build(BuildContext context) {
    final rows = [
      ('合同金额', '${project.contractAmount.toStringAsFixed(1)} 万元'),
      ('签订日期', business?.contractDate ?? '—'),
    ];
    return _BusinessCard(
      icon: Icons.description_outlined,
      title: '合同',
      child: Column(
        children: rows
            .map(
              (r) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    SizedBox(
                      width: 90,
                      child: Text(
                        r.$1,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        r.$2,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

/// 交付：交付物清单
class _DeliveryCard extends StatelessWidget {
  final Project project;

  const _DeliveryCard({required this.project});

  @override
  Widget build(BuildContext context) {
    return _BusinessCard(
      icon: Icons.inventory_2_outlined,
      title: '交付',
      subtitle: '| ${project.doneItems}/${project.totalItems} 已完成',
      child: Column(
        children: project.deliverables
            .map(
              (d) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        d.name,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ),
                    StatusBadge(status: d.status.label),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

/// 结款：收款记录
class _PaymentCard extends StatelessWidget {
  final BusinessInfo? business;

  const _PaymentCard({required this.business});

  @override
  Widget build(BuildContext context) {
    final payments = business?.payments ?? const <Payment>[];
    final received = payments
        .where((p) => p.status == '已收')
        .fold<double>(0, (s, p) => s + p.amount);
    final total = payments.fold<double>(0, (s, p) => s + p.amount);

    return _BusinessCard(
      icon: Icons.account_balance_wallet_outlined,
      title: '结款',
      subtitle: total > 0
          ? '| 已收 ${received.toStringAsFixed(1)} / ${total.toStringAsFixed(1)} 万'
          : '',
      child: payments.isEmpty
          ? const Text(
              '暂无结款记录',
              style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
            )
          : Column(
              children: payments
                  .map(
                    (p) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              p.name,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                          ),
                          Text(
                            '${p.amount.toStringAsFixed(1)} 万',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            p.date.isEmpty ? '—' : p.date,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                          const SizedBox(width: 12),
                          StatusBadge(status: p.status),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
    );
  }
}

/// 商务管理阶段：调研 → 谈判 → 实施 → 验收 → 复盘（矩阵列状态）
class _BusinessFlowCard extends StatelessWidget {
  final ProjectMatrix matrix;

  const _BusinessFlowCard({required this.matrix});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            icon: Icons.flag_outlined,
            title: '商务管理阶段',
            subtitle: '| 调研 → 复盘',
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              for (var i = 0; i < matrix.columns.length; i++) ...[
                if (i > 0)
                  Expanded(
                    child: Container(
                      height: 2,
                      margin: const EdgeInsets.only(bottom: 18),
                      color: matrix.columns[i - 1].status == ItemStatus.done
                          ? const Color(0xFF10B981)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                _StepDot(
                  status: matrix.columns[i].status,
                  label: matrix.columns[i].label,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  final ItemStatus status;
  final String label;

  const _StepDot({required this.status, required this.label});

  @override
  Widget build(BuildContext context) {
    final color = status.color;
    return Column(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
        ),
      ],
    );
  }
}
