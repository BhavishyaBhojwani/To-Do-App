import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';

class FirebaseService {
  final CollectionReference _taskCollection = FirebaseFirestore.instance.collection('tasks');

  Future<List<Task>> getTasks() async {
    var snapshot = await _taskCollection.get();
    return snapshot.docs.map((doc) => Task.fromJson(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<void> addTask(Task task) async {
    await _taskCollection.doc(task.id).set(task.toJson());
  }

  Future<void> updateTask(Task task) async {
    await _taskCollection.doc(task.id).update(task.toJson());
  }

  Future<void> deleteTask(String id) async {
    await _taskCollection.doc(id).delete();
  }
}
