import 'package:isar/isar.dart';

part 'task.g.dart';

@collection
class Task {
  Id id = Isar.autoIncrement;

  late String title;
  late String description;
  late DateTime dateTime;
  bool isDone = false;
  late TaskType taskType;
}

@embedded
class TaskType {
  late String image;
  late String title;
  @enumerated
  late TaskTypeEnum taskTypeEnum;
}

enum TaskTypeEnum { focus, working, date }
