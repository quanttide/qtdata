import 'package:flutter/material.dart';

import '../models/business_info.dart';
import 'business_card.dart';

/// 报价：成本法 / 市场法 / 内部价
class QuotationCard extends StatelessWidget {
  final BusinessInfo? business;

  const QuotationCard({super.key, required this.business});

  @override
  Widget build(BuildContext context) {
    final b = business;
    final items = [
      ('成本法', b?.costBased ?? 0),
      ('市场法', b?.marketBased ?? 0),
      ('内部价', b == null ? 0 : b.costBased * 1.6),
    ];
    return BusinessCard(
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
