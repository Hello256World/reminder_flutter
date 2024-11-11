import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:isar/isar.dart';
import 'package:reminder_flutter/data/constants/constants.dart';
import 'package:reminder_flutter/data/models/task.dart';
import 'package:reminder_flutter/data/widgets/task_widget.dart';
import 'package:reminder_flutter/main.dart';
import 'package:reminder_flutter/screens/add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isChecked = false;
  ValueNotifier<List<Task>> taskNotifire =
      ValueNotifier(isar.tasks.where().findAllSync());
  Stream<void> taskChange = isar.tasks.watchLazy();
  bool showFab = true;

  @override
  void initState() {
    super.initState();
    taskChange.listen((_) {
      taskNotifire.value = isar.tasks.where().findAllSync();
    });
  }

  @override
  void dispose() {
    taskNotifire.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greyColor,
      body: ValueListenableBuilder(
        valueListenable: taskNotifire,
        builder: (context, value, child) {
          return NotificationListener<UserScrollNotification>(
            onNotification: (notification) {
              setState(() {
                if (notification.direction == ScrollDirection.reverse) {
                  showFab = false;
                } else if (notification.direction == ScrollDirection.forward) {
                  showFab = true;
                }
              });

              return true;
            },
            child: ListView.builder(
              itemCount: value.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    _deleteTask(value[index].id);
                  },
                  child: TaskWidget(task: value[index]),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: showFab
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddTaskScreen()));
              },
              backgroundColor: greenColor,
              child: Image.asset('images/icon_add.png'),
            )
          : null,
    );
  }

  Future<void> _deleteTask(int id) async {
    await isar.writeTxn(() async {
      await isar.tasks.delete(id);
    });
  }
}
