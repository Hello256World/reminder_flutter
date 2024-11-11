import 'package:flutter/material.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:reminder_flutter/data/constants/constants.dart';
import 'package:reminder_flutter/data/models/task.dart';
import 'package:reminder_flutter/main.dart';
import 'package:reminder_flutter/screens/edit_task_screen.dart';

class TaskWidget extends StatefulWidget {
  const TaskWidget({super.key, required this.task});
  final Task task;
  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  late bool isChecked;

  @override
  void initState() {
    super.initState();
    isChecked = widget.task.isDone;
  }

  @override
  Widget build(BuildContext context) {
    return _reminderBox();
  }

  Widget _reminderBox() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isChecked = !isChecked;
        });
        _updateDb();
      },
      child: Container(
        height: 132,
        margin: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      MSHCheckbox(
                        size: 32,
                        colorConfig:
                            MSHColorConfig.fromCheckedUncheckedDisabled(
                          checkedColor: greenColor,
                        ),
                        style: MSHCheckboxStyle.stroke,
                        value: isChecked,
                        onChanged: (selected) {
                          setState(() {
                            isChecked = selected;
                          });
                          _updateDb();
                        },
                      ),
                      Spacer(),
                      Text(widget.task.title),
                    ],
                  ),
                  SizedBox(height: 5),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      widget.task.description,
                      textDirection: TextDirection.rtl,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Container(
                        width: 90,
                        height: 32,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: greenColor,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: greyColor,
                              spreadRadius: 2,
                              offset: Offset(0.0, 3.0),
                              blurRadius: 2,
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${_time(widget.task.dateTime.hour)}:${_time(widget.task.dateTime.minute)}',
                              style: TextStyle(color: whiteColor),
                            ),
                            SizedBox(width: 10),
                            Image.asset(
                              'images/icon_time.png',
                              height: 18,
                            )
                          ],
                        ),
                      ),
                      SizedBox(width: 15),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditTaskScreen(
                                task: widget.task,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: 90,
                          height: 32,
                          decoration: BoxDecoration(
                            color: lightGreenColor,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: greyColor,
                                spreadRadius: 1,
                                offset: Offset(0.0, 3.0),
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'ویرایش',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: greenColor,
                                ),
                              ),
                              SizedBox(width: 10),
                              Image.asset('images/icon_edit.png'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Image.asset(widget.task.taskType.image),
          ],
        ),
      ),
    );
  }

  Future<void> _updateDb() async {
    await isar.writeTxn(() async {
      var task = await isar.tasks.get(widget.task.id);
      if (task != null) {
        task.isDone = isChecked;
        await isar.tasks.put(task);
      }
    });
  }

  String _time(int time) {
    if (time > 9) {
      return '$time';
    }

    return '0$time';
  }
}
