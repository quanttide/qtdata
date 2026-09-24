import 'package:flutter/material.dart';

import '../models/project.dart';
import 'business_card.dart';
import 'status_badge.dart';

/// 交付：交付物清单
class DeliveryCard extends StatelessWidget {
  final Project project;

  const DeliveryCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return BusinessCard(
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
