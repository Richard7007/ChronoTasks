import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list/task_model/task_models.dart';

import 'build_icon_button.dart';
import 'build_text_widget.dart';

class PendingTask extends StatefulWidget {
  const PendingTask({
    Key? key,
  });

  @override
  State<PendingTask> createState() => _PendingTaskState();
}

class _PendingTaskState extends State<PendingTask> {
  List<TaskModels> taskList = [];

  bool isLoading = false;
  int currentIndex = 0;
  int selectedIndex = 0;

  fetchPendingData(String orderByField, bool ascending) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("task")
          .orderBy(orderByField, descending: !ascending)
          .where("dueDate",
          isGreaterThan:
          DateFormat('dd/MM/yyyy').format(DateTime.now()))
          .get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        TaskModels taskModels =
        TaskModels.fromJson(doc.data() as Map<String, dynamic>);
        taskList.add(taskModels);
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      // ignore_for_file: avoid_print
      print(e.toString());
    }
  }

  List<TaskModels> toDoList = [];
  bool taskCompleted = true;
  bool isDeleted = false;
  PageController pageController = PageController();
  @override
  void initState() {
    fetchPendingData("dueDate", true);
    super.initState();



    toDoList = [];
    _fetchTasks();
    setState(() {
      isLoading = true;
    });
  }

  Future<void> _fetchTasks() async {
    final QuerySnapshot snapshot =
    await FirebaseFirestore.instance.collection('task').get();
    setState(() {
      toDoList = snapshot.docs
          .map((doc) => TaskModels(
        description: doc['description'],
        dueDate: doc['dueDate'],
        dueTime: doc['dueTime'],
      ))
          .toList();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: isLoading
          ? const SpinKitFadingFour(
        color: Colors.cyan,
      )
          : SizedBox(
        height: MediaQuery.of(context).size.height / 1.2,
        child: PageView(
          controller: pageController,
          onPageChanged: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 2.5,
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 10, left: 9),
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: taskList.length,
                itemBuilder: (BuildContext context, int index) {
                  final task = taskList[index];
                  if (task.isDeleted ?? false) {
                    return Container();
                  }
                  if (isDeleted == false) {
                    return Column(
                      children: [
                        ListTile(
                          onTap: () async {
                            setState(() {
                              print(task.dueDate);
                              print(DateFormat('dd/MM/yyyy')
                                  .format(DateTime.now()));

                              task.taskCompleted =
                              !(task.taskCompleted ?? false);
                              task.isDeleted = !(task.isDeleted ?? false);
                            });
                            final taskRef = FirebaseFirestore.instance
                                .collection("task");
                            final querySnapshot = await taskRef
                                .where("description",
                                isEqualTo: task.description)
                                .limit(1)
                                .get();
                            if (querySnapshot.docs.isNotEmpty) {
                              final docId = querySnapshot.docs.first.id;
                              await taskRef
                                  .doc(docId)
                                  .update({"isDeleted": task.isDeleted});
                            }
                            if (querySnapshot.docs.isNotEmpty) {
                              final docId = querySnapshot.docs.first.id;
                              await taskRef.doc(docId).update(
                                  {"taskCompleted": task.taskCompleted});
                            }
                          },
                          title: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: task.taskCompleted ?? false
                                      ? Colors.white38
                                      : Colors.cyan.shade400,
                                  width:
                                  MediaQuery.of(context).size.width /
                                      400,
                                ),
                              ),
                              child: SizedBox(
                                width: 300,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ListTile(
                                      leading: BuildIconButton(
                                        icon: task.taskCompleted ?? false
                                            ? const Icon(
                                          Icons.task,
                                          color: Colors.cyan,
                                          size: 20,
                                        )
                                            : const Icon(
                                          Icons.pending_actions,
                                          color: Colors.cyan,
                                          size: 20,
                                        ),
                                        onPressed: () async {
                                          setState(() {
                                            task.taskCompleted =
                                            !(task.taskCompleted ??
                                                false);
                                            task.isDeleted =
                                            !(task.isDeleted ??
                                                false);
                                          });

                                          final taskRef =
                                          FirebaseFirestore.instance
                                              .collection("task");
                                          final querySnapshot =
                                          await taskRef
                                              .where("description",
                                              isEqualTo: task
                                                  .description)
                                              .limit(1)
                                              .get();

                                          if (querySnapshot
                                              .docs.isNotEmpty) {
                                            final docId = querySnapshot
                                                .docs.first.id;
                                            await taskRef
                                                .doc(docId)
                                                .update({
                                              "taskCompleted":
                                              task.taskCompleted
                                            });
                                          }
                                          if (querySnapshot
                                              .docs.isNotEmpty) {
                                            final docId = querySnapshot
                                                .docs.first.id;
                                            await taskRef
                                                .doc(docId)
                                                .update({
                                              "isDeleted": task.isDeleted
                                            });
                                          }
                                        },
                                      ),
                                      title: BuildTextWidget(
                                        text: task.title,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:
                                          task.taskCompleted ?? false
                                              ? Colors.white38
                                              : Colors.white,
                                          fontSize: 20,
                                          decoration:
                                          task.taskCompleted ?? false
                                              ? TextDecoration
                                              .lineThrough
                                              : TextDecoration.none,
                                        ),
                                      ),
                                      trailing: Column(
                                        children: [
                                          BuildTextWidget(
                                            text: task.dueDate,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          BuildTextWidget(
                                            text: task.dueTime,
                                            style: TextStyle(
                                              color: task.taskCompleted ??
                                                  false
                                                  ? Colors.white38
                                                  : Colors.white,
                                              fontSize: 10,
                                              decoration:
                                              task.taskCompleted ??
                                                  false
                                                  ? TextDecoration
                                                  .lineThrough
                                                  : TextDecoration
                                                  .none,
                                            ),
                                          ),
                                          const Spacer(),
                                          BuildTextWidget(
                                            text: 'Created on:',
                                            style: TextStyle(
                                              color: task.taskCompleted ??
                                                  false
                                                  ? Colors.white38
                                                  : Colors.cyan,
                                              fontSize: 9,
                                              decoration:
                                              task.taskCompleted ??
                                                  false
                                                  ? TextDecoration
                                                  .lineThrough
                                                  : TextDecoration
                                                  .none,
                                            ),
                                          ),
                                          BuildTextWidget(
                                            text: DateFormat.yMd()
                                                .format(DateTime.now()),
                                            style: TextStyle(
                                              color: task.taskCompleted ??
                                                  false
                                                  ? Colors.white38
                                                  : Colors.cyan,
                                              fontSize: 9,
                                              decoration:
                                              task.taskCompleted ??
                                                  false
                                                  ? TextDecoration
                                                  .lineThrough
                                                  : TextDecoration
                                                  .none,
                                            ),
                                          ),
                                        ],
                                      ),
                                      subtitle: BuildTextWidget(
                                        text: task.description,
                                        style: TextStyle(
                                          color:
                                          task.taskCompleted ?? false
                                              ? Colors.white38
                                              : Colors.white,
                                          fontSize: 13,
                                          decoration:
                                          task.taskCompleted ?? false
                                              ? TextDecoration
                                              .lineThrough
                                              : TextDecoration.none,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}



