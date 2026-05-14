import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qtdata_data/qtdata_data.dart';

void main() {
  group('DatasetPanel', () {
    testWidgets('shows datasets when provided', (tester) async {
      final datasets = [
        Dataset(id: '1', name: 'ds1', title: 'Dataset 1', schemaId: 's1', status: DatasetStatus.ready),
        Dataset(id: '2', name: 'ds2', title: 'Dataset 2', schemaId: 's2', status: DatasetStatus.pending),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DatasetPanel(datasets: datasets),
          ),
        ),
      );

      expect(find.text('数据集'), findsOneWidget);
      expect(find.text('ds1'), findsOneWidget);
      expect(find.text('ds2'), findsOneWidget);
    });

    testWidgets('renders nothing for empty datasets', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DatasetPanel(datasets: []),
          ),
        ),
      );

      expect(find.text('数据集'), findsNothing);
      expect(find.byType(DatasetCard), findsNothing);
    });
  });
}
