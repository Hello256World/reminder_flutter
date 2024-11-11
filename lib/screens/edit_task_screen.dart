import 'package:flutter/material.dart';
import 'package:reminder_flutter/data/constants/constants.dart';
import 'package:reminder_flutter/data/models/task.dart';
import 'package:reminder_flutter/data/widgets/task_type_widget.dart';
import 'package:reminder_flutter/main.dart';
import 'package:time_pickerr/time_pickerr.dart';

class EditTaskScreen extends StatefulWidget {
  const EditTaskScreen({super.key, required this.task});
  final Task task;

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  FocusNode titleFocusNode = FocusNode();
  FocusNode descFocusNode = FocusNode();
  late TextEditingController titleController;
  late TextEditingController descController;
  late int selectedItem;
  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task.title);
    descController = TextEditingController(text: widget.task.description);
    selectedItem = getTaskTypes().indexWhere((element) {
      return element.taskTypeEnum == widget.task.taskType.taskTypeEnum;
    });
    titleFocusNode.addListener(() {
      setState(() {});
    });

    descFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 50),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 300,
              height: 50,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: TextField(
                  controller: titleController,
                  focusNode: titleFocusNode,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(right: 20),
                    labelText: 'عنوان تسک',
                    labelStyle: TextStyle(
                      color: titleFocusNode.hasFocus
                          ? greenColor
                          : Color(0xffC5C5C5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(17),
                      borderSide:
                          BorderSide(width: 2, color: Color(0xffC5C5C5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(17),
                      borderSide: BorderSide(
                        width: 2,
                        color: greenColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 25),
          SizedBox(
            width: 300,
            height: 100,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: TextField(
                controller: descController,
                focusNode: descFocusNode,
                maxLines: 2,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(right: 20, top: 30),
                  labelText: 'توضیحات تسک',
                  labelStyle: TextStyle(
                    color:
                        descFocusNode.hasFocus ? greenColor : Color(0xffC5C5C5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(17),
                    borderSide: BorderSide(
                      width: 2,
                      color: Color(0xffC5C5C5),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(17),
                    borderSide: BorderSide(color: greenColor, width: 2),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 340,
            height: 320,
            child: Material(
              elevation: 5,
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: CustomHourPicker(
                  positiveButtonText: 'انتخاب زمان',
                  negativeButtonText: 'لغو',
                  title: 'زمان تسک را انتخاب کنید',
                  titleStyle: TextStyle(
                    color: greenColor,
                    fontWeight: FontWeight.bold,
                  ),
                  positiveButtonStyle: TextStyle(
                    color: greenColor,
                    fontWeight: FontWeight.bold,
                  ),
                  negativeButtonStyle: TextStyle(
                    color: Colors.red,
                  ),
                  date: widget.task.dateTime,
                  onPositivePressed: (context, time) {
                    widget.task.dateTime = time;
                  },
                  onNegativePressed: (context) {},
                ),
              ),
            ),
          ),
          SizedBox(height: 25),
          SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: getTaskTypes().length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedItem = index;
                      });
                    },
                    child: TaskTypeWidget(
                      taskType: getTaskTypes()[index],
                      index: index,
                      selectedItem: selectedItem,
                    ),
                  ),
                );
              },
            ),
          ),
          Spacer(),
          ElevatedButton(
              onPressed: _updateTaskToDb,
              style: ElevatedButton.styleFrom(
                backgroundColor: greenColor,
                foregroundColor: whiteColor,
                minimumSize: Size(200, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('ویرایش کردن تسک')),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Future<void> _updateTaskToDb() async {
    await isar.writeTxn(() async {
      final task = await isar.tasks.get(widget.task.id);

      if (task != null) {
        task.title = titleController.text;
        task.description = descController.text;
        task.isDone = false;
        task.dateTime = widget.task.dateTime;
        task.taskType = getTaskTypes()[selectedItem];
        await isar.tasks.put(task);
      }
    });

    Navigator.pop(context);
  }
}
