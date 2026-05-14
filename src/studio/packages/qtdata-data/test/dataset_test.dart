import 'package:flutter_test/flutter_test.dart';
import 'package:qtdata_data/qtdata_data.dart';

void main() {
  group('DatasetStatus', () {
    test('pending is the default', () {
      expect(DatasetStatus.pending.index, 0);
    });

    test('values contain all four statuses', () {
      expect(DatasetStatus.values, [
        DatasetStatus.pending,
        DatasetStatus.ready,
        DatasetStatus.outdated,
        DatasetStatus.failed,
      ]);
    });
  });

  group('Dataset', () {
    test('default status is pending', () {
      final ds = Dataset(id: '1', name: 'ds1', title: 'Dataset 1');
      expect(ds.status, DatasetStatus.pending);
    });

    test('can be created with all fields', () {
      final ds = Dataset(
        id: '1',
        name: 'sales/orders',
        title: '销售订单',
        description: '原始销售订单数据',
        schemaName: 'orders_schema',
        status: DatasetStatus.ready,
      );
      expect(ds.name, 'sales/orders');
      expect(ds.title, '销售订单');
      expect(ds.schemaName, 'orders_schema');
      expect(ds.status, DatasetStatus.ready);
    });
  });
}
