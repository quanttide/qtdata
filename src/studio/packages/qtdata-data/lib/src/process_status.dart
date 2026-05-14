import 'package:flutter/material.dart';

enum ProcessStatus {
  pending,
  running,
  completed,
  failed;

  String get label {
    switch (this) {
      case ProcessStatus.pending:
        return '就绪';
      case ProcessStatus.running:
        return '执行中';
      case ProcessStatus.completed:
        return '达标';
      case ProcessStatus.failed:
        return '异常';
    }
  }

  Color get borderColor {
    switch (this) {
      case ProcessStatus.pending:
        return const Color(0xFFE5E5E5);
      case ProcessStatus.running:
        return const Color(0xFF93C5FD);
      case ProcessStatus.completed:
        return const Color(0xFF86EFAC);
      case ProcessStatus.failed:
        return const Color(0xFFFCA5A5);
    }
  }

  Color get textColor {
    switch (this) {
      case ProcessStatus.pending:
        return const Color(0xFF9CA3AF);
      case ProcessStatus.running:
        return const Color(0xFF2563EB);
      case ProcessStatus.completed:
        return const Color(0xFF16A34A);
      case ProcessStatus.failed:
        return const Color(0xFFDC2626);
    }
  }
}
