// To parse this JSON data, do
//
//     final taskModels = taskModelsFromJson(jsonString);

import 'dart:convert';

TaskModels taskModelsFromJson(String str) => TaskModels.fromJson(json.decode(str));

String taskModelsToJson(TaskModels data) => json.encode(data.toJson());

class TaskModels {
  String? id;
  String? title;
  String? description;
  String? dueDate;
  String? dueTime;
  String? createdTime;
  bool? taskCompleted;
  bool? isDeleted;

  TaskModels({
    this.id,
    this.title,
    this.description,
    this.dueDate,
    this.dueTime,
    this.createdTime,
    this.taskCompleted,
    this.isDeleted,
  });

  factory TaskModels.fromJson(Map<String, dynamic> json) => TaskModels(
    title: json["title"],
    description: json["description"],
    dueDate: json["dueDate"],
    dueTime: json["dueTime"],
    createdTime: json["createdTime"],
    taskCompleted: json["taskCompleted"],
    isDeleted: json["isDeleted"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "dueDate": dueDate,
    "dueTime": dueTime,
    "createdTime": createdTime,
    "taskCompleted": taskCompleted,
    "isDeleted":isDeleted
  };
}
