import 'TaskStatus.dart';
import 'Member.dart';
import 'TaskPriority.dart';

class Task {
  static int _id = 0;

  late int id;
  String taskName;
  DateTime startDate;
  DateTime endDate;
  TaskStatus status;
  Member assignTo;
  Taskpriority priority;

  Task(
      {required this.taskName,
      required this.startDate,
      required this.endDate,
      required this.status,
      required this.assignTo,
      required this.priority}) {
    id = ++Task._id;
    status = TaskStatus.notStarted;
    assignTo = Member.sam;
    priority = Taskpriority.low;
  }
}
