import 'package:flutter/material.dart';

import '../models/business_info.dart';
import '../../project/models/project.dart';
import './business_card.dart';

/// 合同：金额 / 签订日期
class ContractCard extends StatelessWidget {
  final Project project;
  final BusinessInfo? business;

  const ContractCard({
    super.key,
    required this.project,
    required this.business,
  });

  @override
  Widget build(BuildContext context) {
    final rows = [
      ('合同金额', '${project.contractAmount.toStringAsFixed(1)} 万元'),
      ('签订日期', business?.contractDate ?? '—'),
    ];
    return BusinessCard(
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
