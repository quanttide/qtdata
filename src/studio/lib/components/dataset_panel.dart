import 'package:flutter/material.dart';
import 'package:quanttide_data/quanttide_data.dart';
import 'dataset_card.dart';

class DatasetPanel extends StatelessWidget {
  final List<Dataset> datasets;

  const DatasetPanel({super.key, required this.datasets});

  @override
  Widget build(BuildContext context) {
    if (datasets.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(32, 12, 32, 12),
          child: Text(
            '数据集',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final dataset in datasets)
                DatasetCard(dataset: dataset),
            ],
          ),
        ),
      ],
    );
  }
}
