import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String id;
  String title;
  String description;
  int priorityLevel;
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

  factory Task.fromDocument(DocumentSnapshot doc) {
    return Task(
      id: doc.id,
      title: doc['title'],
      description: doc['description'],
      priorityLevel: doc['priorityLevel'],
      dueDate: doc['dueDate'],
      isCompleted: doc['isCompleted'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'priorityLevel': priorityLevel,
      'dueDate': dueDate,
      'isCompleted': isCompleted,
    };
  }
}
