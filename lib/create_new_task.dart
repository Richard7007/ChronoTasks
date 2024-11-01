import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list/build_text_form_field_widget.dart';
import 'package:to_do_list/build_text_widget.dart';
import 'package:to_do_list/home_page.dart';
import 'package:to_do_list/task_model/task_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'build_icon_button.dart';
import 'build_text_button.dart';

class CreateNewTask extends StatefulWidget {
  const CreateNewTask({super.key});

  @override
  State<CreateNewTask> createState() => _CreateNewTaskState();
}

class _CreateNewTaskState extends State<CreateNewTask> {
  TimeOfDay _time = TimeOfDay.now();

  //   switch (day) {  // String getMonthInWords(int day) {
  //     case 1:
  //       return "January";
  //     case 2:
  //       return "February";
  //     case 3:
  //       return "March";
  //     case 4:
  //       return "April";
  //     case 5:
  //       return "May";
  //     case 6:
  //       return "June";
  //     case 7:
  //       return "July";
  //     case 8:
  //       return "August";
  //     case 9:
  //       return "September";
  //     case 10:
  //       return "October";
  //     case 11:
  //       return "November";
  //     case 12:
  //       return "December";
  //     default:
  //       return "";
  //   }
  // }

  void _selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
        setState(() {
          final String period = newTime.period == DayPeriod.am ? 'AM' : 'PM';
          final String formattedTime =
              '${newTime.hourOfPeriod < 10 ? '0${newTime.hourOfPeriod}' : newTime.hourOfPeriod}:${newTime.minute < 10 ? '0${newTime.minute}' : newTime.minute} $period';
          timeController.text = formattedTime;
        });
      });
    }
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<TaskModels> toDoList = [];
  final _fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.cyan.shade400,
        leading: BuildIconButton(
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ));
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.black,
          ),
        ),
        title: const BuildTextWidget(
          text: 'Create New Task',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(30, 18, 0, 0),
                child: BuildTextWidget(
                  text: 'Title',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                child: BuildTextFormFieldWidget(
                  controller: titleController,
                  textInputType: TextInputType.text,
                  suffixIcon: const Icon(Icons.mic),
                  textAlign: TextAlign.start,
                  readOnly: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter title';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    suffixIconColor: Colors.white,
                    hintText: '    Enter Title',
                    hintStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontSize: 11),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(30, 18, 0, 0),
                child: BuildTextWidget(
                  text: 'Description',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                child: BuildTextFormFieldWidget(
                  textInputType: TextInputType.text,
                  controller: descriptionController,
                  textAlign: TextAlign.start,
                  readOnly: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Description';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    suffixIconColor: Colors.white,
                    hintText: '    Enter Description',
                    hintStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontSize: 11),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 80,
              ),
              Row(
                children: [
                  Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 55, 0),
                        child: BuildTextWidget(
                          text: 'Due Date',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.80,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(35, 10, 30, 10),
                          child: BuildTextFormFieldWidget(
                            textAlign: TextAlign.center,
                            readOnly: true,
                            size: 12,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Select Date';
                              }
                              return null;
                            },
                            suffixIcon: const Icon(
                              Icons.date_range,
                              color: Colors.white,
                            ),
                            controller: dateController,
                            onTapped: () async {
                              DateTime? selectedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2100),
                              );
                              if (selectedDate != null) {
                                setState(() {
                                  // var monthWords =
                                  //     getMonthInWords(selectedDate.month);
                                  var date =
                                      "${selectedDate.day}/${selectedDate.month < 10 ? '0${selectedDate.month}' : selectedDate.month}/${selectedDate.year} ";
                                  dateController.text = date.toString();
                                });
                              }
                            },
                            decoration: InputDecoration(
                              suffixIconColor: Colors.white,
                              label: const Text(
                                ' Select Date',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              labelStyle: const TextStyle(
                                fontSize: 11,
                              ),
                              suffixIcon: const Icon(
                                Icons.date_range,
                                color: Colors.white,
                              ),
                              hintStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 75, 0),
                        child: BuildTextWidget(
                          text: 'Due Time',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.25,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 25, 10),
                          child: BuildTextFormFieldWidget(
                            textAlign: TextAlign.center,
                            controller: timeController,
                            size: 12,
                            readOnly: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Select Time';
                              }
                              return null;
                            },
                            onTapped: _selectTime,
                            decoration: const InputDecoration(
                              label: Text(
                                'Select Time',
                                style: TextStyle(color: Colors.white),
                              ),
                              labelStyle: TextStyle(fontSize: 11),
                              suffixIcon: Icon(
                                Icons.timelapse_rounded,
                                color: Colors.white,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 3.33,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.cyan.shade400,
        height: MediaQuery.of(context).size.height / 13.33,
        child: BuildTextButton(
            text: 'Save',
            textColor: Colors.black,
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _fireStore.collection('task').add({
                  'title': titleController.text,
                  'description': descriptionController.text,
                  'dueDate': dateController.text,
                  'dueTime': timeController.text,
                  'docId': "",
                  'taskCompleted': false,
                  'isDeleted': false,
                  'createdDate': DateFormat.yMd().format(DateTime.now())
                }).then((value) async {
                  await _fireStore
                      .collection('task')
                      .doc(value.id)
                      .update({"docId": value.id});
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                  );
                });
              }
            }),
      ),
    );
  }
}
