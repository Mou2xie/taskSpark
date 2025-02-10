import 'TaskModel.dart';
import 'Member.dart';

class Project {
  static int _id = 0;

  late int id;
  String projectName;
  DateTime startDate;
  DateTime endDate;
  List<Member> members = [];
  List<Task> tasks = [];

  Project(
      {required this.projectName,
      required this.startDate,
      required this.endDate,
      required this.tasks}) {
    id = ++Project._id;
    members = [Member.xie, Member.sam, Member.isha];
  }
}
