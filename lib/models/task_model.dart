import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String id;
  String title;
  String description;
  int priorityLevel; // 1: High, 2: medium, 3: low
  Timestamp dueDate;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.priorityLevel,
    required this.dueDate,
    this.isCompleted = false,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      priorityLevel: json['priorityLevel'],
      dueDate: json['dueDate'],
      isCompleted: json['isCompleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priorityLevel': priorityLevel,
      'dueDate': dueDate,
      'isCompleted': isCompleted,
    };
  }
}
