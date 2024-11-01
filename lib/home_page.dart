import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list/build_icon_button.dart';
import 'package:to_do_list/pending_task.dart';
import 'package:to_do_list/task_model/task_models.dart';
import 'build_text_widget.dart';
import 'create_new_task.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TaskModels> taskList = [];
  List<TaskModels> completedTaskList = [];

  bool isLoading = false;
  int currentIndex = 0;
  int selectedIndex = 0;

  fetchData(String orderByField, bool ascending) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("task")
          .orderBy(orderByField, descending: !ascending)
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
  late FirebaseMessaging messaging;
  PageController pageController = PageController();

  @override
  void initState() {
    fetchData("dueDate", true);
    super.initState();
    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value) {
      print(value);
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved");
      print(event.notification!.body);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.black,
              elevation: 50,
              title: BuildTextWidget(
                text: event.notification!.title!,
                style: const TextStyle(
                  color: Colors.cyan,
                ),
              ),
              content: BuildTextWidget(
                text: event.notification!.body!,
                style: const TextStyle(
                  color: Colors.cyan,
                ),
              ),
              actions: [
                TextButton(
                  child: const BuildTextWidget(
                    text: "OK",
                    style: TextStyle(
                      color: Colors.cyan,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });

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
      extendBody: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const BuildTextWidget(
          text: ' Todo List',
          style: TextStyle(
            color: Colors.black,
            fontSize: 27,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          PopupMenuButton(
            color: Colors.black,
            iconColor: Colors.black,
            onSelected: (value) {},
            itemBuilder: (BuildContext bc) {
              return [
                PopupMenuItem(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: TextButton(
                    child: const BuildTextWidget(
                      text: 'Send Feedback',
                    ),
                    onPressed: () {},
                  ),
                ),
              ];
            },
          )
        ],
        backgroundColor: Colors.cyan.shade400,
      ),
      body: isLoading
          ? const SpinKitFadingFour(
              color: Colors.cyan,
            )
          : SizedBox(
              height: MediaQuery.of(context).size.height / 1.2,
              child: PageView(
                controller: pageController,
                onPageChanged: (index) {
                  setState(() {});
                },
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 2,
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
                  const Center(child: PendingTask())
                ],
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 59),
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 4,
          height: MediaQuery.of(context).size.height / 13.68,
          child: FloatingActionButton(
            shape: const BeveledRectangleBorder(
              side: BorderSide(
                width: 1,
              ),
            ),
            backgroundColor: Colors.black,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateNewTask(),
                  ));
            },
            child: Icon(
              Icons.add,
              color: Colors.cyan.shade400,
              size: 30,
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.cyan.shade400,
        currentIndex: selectedIndex,
        selectedItemColor: Colors.black,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
        unselectedItemColor: Colors.black,
        onTap: (index) {
          setState(() {
            selectedIndex = index;

            pageController.jumpToPage(index);
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width / 7,
              ),
              child: const Icon(
                Icons.pending_actions,
                size: 25,
              ),
            ),
            label: 'Pending Task              ',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width / 7,
              ),
              child: const Icon(
                Icons.task,
                size: 25,
              ),
            ),
            label: '              Task History',
          ),
        ],
      ),
    );
  }
}
