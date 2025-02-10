import 'package:flutter/material.dart';

enum Taskpriority {
  low,
  medium,
  high;

  String get string {
    switch (this) {
      case Taskpriority.low:
        return 'T2';
      case Taskpriority.medium:
        return 'T1';
      case Taskpriority.high:
        return 'T0';
    }
  }

  Color get color {
    switch (this) {
      case Taskpriority.low:
        return Colors.green;
      case Taskpriority.medium:
        return Colors.orange;
      case Taskpriority.high:
        return Colors.red;
    }
  }
}
