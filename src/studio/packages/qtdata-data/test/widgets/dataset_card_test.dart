import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qtdata_data/qtdata_data.dart';

void main() {
  group('DatasetCard', () {
    testWidgets('renders name, title and status', (tester) async {
      final dataset = Dataset(
        id: '1',
        name: 'sales/orders',
        title: '销售订单',
        schemaId: 's1',
        status: DatasetStatus.ready,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DatasetCard(dataset: dataset),
          ),
        ),
      );

      expect(find.text('sales/orders'), findsOneWidget);
      expect(find.text('销售订单'), findsOneWidget);
      expect(find.text('已就绪'), findsOneWidget);
    });

    testWidgets('renders different statuses', (tester) async {
      final dataset = Dataset(
        id: '2',
        name: 'raw/data',
        title: '原始数据',
        schemaId: 's2',
        status: DatasetStatus.pending,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DatasetCard(dataset: dataset),
          ),
        ),
      );

      expect(find.text('等待中'), findsOneWidget);
    });
  });
}
