import 'package:flutter/material.dart';

import 'section_header.dart';

/// 卡片外壳
class BusinessCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget child;

  const BusinessCard({
    super.key,
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
