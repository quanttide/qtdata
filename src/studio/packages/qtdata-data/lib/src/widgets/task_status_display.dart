import 'package:flutter/material.dart';
import '../task_status.dart';

extension TaskStatusDisplay on TaskStatus {
  String get label {
    switch (this) {
      case TaskStatus.pending:
        return '就绪';
      case TaskStatus.running:
        return '执行中';
      case TaskStatus.completed:
        return '达标';
      case TaskStatus.failed:
        return '异常';
    }
  }

  Color get borderColor {
    switch (this) {
      case TaskStatus.pending:
        return const Color(0xFFE5E5E5);
      case TaskStatus.running:
        return const Color(0xFF93C5FD);
      case TaskStatus.completed:
        return const Color(0xFF86EFAC);
      case TaskStatus.failed:
        return const Color(0xFFFCA5A5);
    }
  }

  Color get textColor {
    switch (this) {
      case TaskStatus.pending:
        return const Color(0xFF9CA3AF);
      case TaskStatus.running:
        return const Color(0xFF2563EB);
      case TaskStatus.completed:
        return const Color(0xFF16A34A);
      case TaskStatus.failed:
        return const Color(0xFFDC2626);
    }
  }
}
