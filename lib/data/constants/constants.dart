import 'dart:ui';

import 'package:reminder_flutter/data/models/task.dart';

const Color greenColor = Color(0xff18DAA3);
const Color lightGreenColor = Color(0xffE2F6F1);
const Color greyColor = Color(0xffE5E5E5);
const Color whiteColor = Color(0xffFFFFFF);

List<TaskType> getTaskTypes() {
  List<TaskType> taskTypes = [
    TaskType()
      ..image = 'images/meditate.png'
      ..title = 'تمرکز'
      ..taskTypeEnum = TaskTypeEnum.focus,
    TaskType()
      ..image = 'images/social_frends.png'
      ..title = 'میتینگ'
      ..taskTypeEnum = TaskTypeEnum.date,
    TaskType()
      ..image = 'images/hard_working.png'
      ..title = 'کار زیاد'
      ..taskTypeEnum = TaskTypeEnum.working,
  ];

  return taskTypes;
}
