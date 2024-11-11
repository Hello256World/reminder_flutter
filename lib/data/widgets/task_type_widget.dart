import 'package:flutter/material.dart';
import 'package:reminder_flutter/data/constants/constants.dart';
import 'package:reminder_flutter/data/models/task.dart';

class TaskTypeWidget extends StatelessWidget {
  const TaskTypeWidget({
    super.key,
    required this.taskType,
    required this.index,
    required this.selectedItem,
  });

  final TaskType taskType;
  final int index;
  final int selectedItem;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        border: Border.all(
          color: selectedItem == index ? greenColor : greyColor,
          width: selectedItem == index ? 3 : 2,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Image.asset(taskType.image),
          Text(taskType.title),
        ],
      ),
    );
  }
}
