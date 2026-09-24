import 'package:flutter/material.dart';

/// 统计卡片的数据（标签 / 计数 / 数字色 / 对应筛选项）
class StatCardData {
  final String label;
  final int count;
  final Color numberColor;
  final String filter;

  const StatCardData({
    required this.label,
    required this.count,
    required this.numberColor,
    required this.filter,
  });
}

/// 统计卡片组：桌面 4 列、移动端 2 列，点击即切换筛选
class StatCards extends StatelessWidget {
  final List<StatCardData> cards;
  final String activeFilter;
  final ValueChanged<String> onSelect;

  const StatCards({
    super.key,
    required this.cards,
    required this.activeFilter,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 640 ? 4 : 2;
        return GridView.count(
          crossAxisCount: columns,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 2.4,
          children: cards
              .map(
                (c) => _StatCard(
                  data: c,
                  active: activeFilter == c.filter,
                  onTap: () => onSelect(c.filter),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final StatCardData data;
  final bool active;
  final VoidCallback onTap;

  const _StatCard({
    required this.data,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: active ? const Color(0xFF4F46E5) : const Color(0xFFF1F5F9),
          ),
          boxShadow: active
              ? const [
                  BoxShadow(
                    color: Color(0x1A4F46E5),
                    blurRadius: 0,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${data.count}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: data.numberColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              data.label,
              style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
            ),
          ],
        ),
      ),
    );
  }
}

/// 筛选按钮组（全部 / 进行中 / 已完成 / 待启动）
class ProjectFilterGroup extends StatelessWidget {
  final String filter;
  final ValueChanged<String> onSelect;

  const ProjectFilterGroup({
    super.key,
    required this.filter,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    const filters = [
      ('全部', 'all'),
      ('进行中', 'active'),
      ('已完成', 'done'),
      ('待启动', 'pending'),
    ];
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: filters.map((f) {
          final (label, value) = f;
          final isActive = filter == value;
          return InkWell(
            onTap: () => onSelect(value),
            borderRadius: BorderRadius.circular(6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isActive ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                boxShadow: isActive
                    ? const [
                        BoxShadow(
                          color: Color(0x14000000),
                          blurRadius: 3,
                          offset: Offset(0, 1),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isActive
                      ? const Color(0xFF1E293B)
                      : const Color(0xFF64748B),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
