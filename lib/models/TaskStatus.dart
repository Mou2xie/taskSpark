enum TaskStatus {
  notStarted,
  inProgress,
  finished;

  String get string {
    switch (this) {
      case TaskStatus.notStarted:
        return 'Not Started';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.finished:
        return 'Finished';
    }
  }
}
