enum DatasetStatus {
  pending('等待中', 0xFF9CA3AF),
  ready('已就绪', 0xFF16A34A),
  outdated('已过时', 0xFFD97706),
  failed('异常', 0xFFDC2626);

  final String label;
  final int color;

  const DatasetStatus(this.label, this.color);
}

class Dataset {
  final String id;
  final String name;
  final String title;
  final String description;
  final String? schemaName;
  final DatasetStatus status;

  const Dataset({
    required this.id,
    required this.name,
    required this.title,
    this.description = '',
    this.schemaName,
    this.status = DatasetStatus.pending,
  });
}
