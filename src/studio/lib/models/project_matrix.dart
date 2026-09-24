import 'project_status.dart';

/// 全流程进度总览（二维网格）的维度行
class MatrixRow {
  final String label;
  final String key;

  const MatrixRow({required this.label, required this.key});

  factory MatrixRow.fromJson(Map<String, dynamic> json) =>
      MatrixRow(label: json['label'] as String, key: json['key'] as String);
}

/// 全流程进度总览（二维网格）的阶段列
class MatrixColumn {
  final String label;
  final String key;
  final ItemStatus status;

  const MatrixColumn({
    required this.label,
    required this.key,
    required this.status,
  });

  factory MatrixColumn.fromJson(Map<String, dynamic> json) => MatrixColumn(
    label: json['label'] as String,
    key: json['key'] as String,
    status: ItemStatus.fromKey(json['status'] as String),
  );
}

/// 全流程进度总览（二维网格）的单元格
class MatrixCell {
  final String name;
  final ItemStatus status;

  const MatrixCell({required this.name, required this.status});

  factory MatrixCell.fromJson(Map<String, dynamic> json) => MatrixCell(
    name: json['name'] as String,
    status: ItemStatus.fromKey(json['status'] as String),
  );
}

/// 全流程进度总览（二维网格）
class ProjectMatrix {
  final List<MatrixRow> rows;
  final List<MatrixColumn> columns;
  final Map<String, MatrixCell> cells;

  const ProjectMatrix({
    required this.rows,
    required this.columns,
    required this.cells,
  });

  /// 按 `行key_列key` 定位单元格
  MatrixCell? cellAt(String rowKey, String colKey) =>
      cells['${rowKey}_$colKey'];

  factory ProjectMatrix.fromJson(Map<String, dynamic> json) => ProjectMatrix(
    rows: (json['rows'] as List<dynamic>)
        .map((e) => MatrixRow.fromJson(e as Map<String, dynamic>))
        .toList(),
    columns: (json['columns'] as List<dynamic>)
        .map((e) => MatrixColumn.fromJson(e as Map<String, dynamic>))
        .toList(),
    cells: (json['cells'] as Map<String, dynamic>).map(
      (key, value) =>
          MapEntry(key, MatrixCell.fromJson(value as Map<String, dynamic>)),
    ),
  );
}
