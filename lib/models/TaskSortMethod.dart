enum TaskSortMethod {
  by_time,
  by_priority;

  String get string {
    switch (this) {
      case TaskSortMethod.by_time:
        return 'Sort by Time';
      case TaskSortMethod.by_priority:
        return 'Sort by Priority';
    }
  }
} 