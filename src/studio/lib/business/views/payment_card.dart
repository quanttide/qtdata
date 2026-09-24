import 'package:flutter/material.dart';

import '../models/business_info.dart';
import './business_card.dart';
import '../../app/views/status_badge.dart';

/// 结款：收款记录
class PaymentCard extends StatelessWidget {
  final BusinessInfo? business;

  const PaymentCard({super.key, required this.business});

  @override
  Widget build(BuildContext context) {
    final payments = business?.payments ?? const <Payment>[];
    final received = payments
        .where((p) => p.status == '已收')
        .fold<double>(0, (s, p) => s + p.amount);
    final total = payments.fold<double>(0, (s, p) => s + p.amount);

    return BusinessCard(
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
