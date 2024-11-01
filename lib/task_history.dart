import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list/build_icon_button.dart';
import 'package:to_do_list/task_model/task_models.dart';
import 'build_text_widget.dart';

class TaskHistory extends StatefulWidget {
  const TaskHistory({super.key});

  @override
  State<TaskHistory> createState() => _TaskHistoryState();
}

class _TaskHistoryState extends State<TaskHistory> {
  int currentIndex = 1;
  int selectedIndex = 0;
  List<TaskModels> taskList = [];
  bool isLoading = false;

  _fetchTaskHistory(String orderByField, bool ascending) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("task")
          .orderBy(orderByField, descending: !ascending)
          .get();
      List<TaskModels> fetchedTasks = [];
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        TaskModels taskModels =
            TaskModels.fromJson(doc.data() as Map<String, dynamic>);
        fetchedTasks.add(taskModels);
      }
      fetchedTasks.sort((a, b) => (b.dueDate ?? '').compareTo(a.dueDate ?? ''));
      fetchedTasks.sort((a, b) => (b.dueTime ?? '').compareTo(a.dueTime ?? ''));
      setState(() {
        taskList = fetchedTasks;
        isLoading = false;
      });
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    _fetchTaskHistory("dueDate", false);
    setState(() {
      isLoading = true;
    });
  }

  PageController pageController = PageController();
  bool isDeleted = true;

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
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 80,
                            left: 9),
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: taskList.length,
                        itemBuilder: (BuildContext context, int index) {
                          final task = taskList[index];
                          if (task.isDeleted ?? false) {
                            return Column(
                              children: [
                                ListTile(
                                  title: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.white38,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              400,
                                        ),
                                      ),
                                      child: SizedBox(
                                        width: 300,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            ListTile(
                                              leading: const BuildIconButton(
                                                icon: Icon(
                                                  Icons.task,
                                                  color: Colors.green,
                                                  size: 20,
                                                ),
                                              ),
                                              title: BuildTextWidget(
                                                text: task.title,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white38,
                                                  fontSize: 20,
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                ),
                                              ),
                                              trailing: Column(
                                                children: [
                                                  BuildTextWidget(
                                                    text: task.dueDate,
                                                    style: const TextStyle(
                                                      color: Colors.white38,
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                    ),
                                                  ),
                                                  BuildTextWidget(
                                                    text: task.dueTime,
                                                    style: const TextStyle(
                                                      color: Colors.white38,
                                                      fontSize: 10,
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  const BuildTextWidget(
                                                    text: 'Created on:',
                                                    style: TextStyle(
                                                      color: Colors.white38,
                                                      fontSize: 9,
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                    ),
                                                  ),
                                                  BuildTextWidget(
                                                    text: DateFormat.yMMMd()
                                                        .format(DateTime.now()),
                                                    style: const TextStyle(
                                                      color: Colors.white38,
                                                      fontSize: 9,
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              subtitle: BuildTextWidget(
                                                text: task.description,
                                                style: const TextStyle(
                                                  color: Colors.white38,
                                                  fontSize: 13,
                                                  decoration: TextDecoration
                                                      .lineThrough,
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
                          }
                          else if (isDeleted == true &&
                              DateFormat('dd/MM/yyyy')
                                      .format(DateTime.now())
                                      .compareTo(task.dueDate.toString()) >=
                                  0) {
                            return Column(
                              children: [
                                ListTile(
                                  title: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.white38,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
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
                                                icon: Icon(
                                                  Icons.dangerous,
                                                  color: Colors.red,
                                                  size: 20,
                                                ),
                                                onPressed: () {
                                                  print(DateFormat('dd/MM/yyyy')
                                                      .format(DateTime.now()));
                                                  print(task.dueDate);
                                                },
                                              ),
                                              title: BuildTextWidget(
                                                text: task.title,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white38,
                                                  fontSize: 20,
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                ),
                                              ),
                                              trailing: Column(
                                                children: [
                                                  BuildTextWidget(
                                                    text: task.dueDate,
                                                    style: const TextStyle(
                                                      color: Colors.white38,
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                    ),
                                                  ),
                                                  BuildTextWidget(
                                                    text: task.dueTime,
                                                    style: const TextStyle(
                                                      color: Colors.white38,
                                                      fontSize: 10,
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  const BuildTextWidget(
                                                    text: 'Created on:',
                                                    style: TextStyle(
                                                      color: Colors.white38,
                                                      fontSize: 9,
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                    ),
                                                  ),
                                                  BuildTextWidget(
                                                    text: DateFormat.yMMMd()
                                                        .format(DateTime.now()),
                                                    style: const TextStyle(
                                                      color: Colors.white38,
                                                      fontSize: 9,
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              subtitle: BuildTextWidget(
                                                text: task.description,
                                                style: const TextStyle(
                                                  color: Colors.white38,
                                                  fontSize: 13,
                                                  decoration: TextDecoration
                                                      .lineThrough,
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
                            return const SizedBox();
                          }
                        }),
                  ),
                ],
              ),
            ),
    );
  }
}
