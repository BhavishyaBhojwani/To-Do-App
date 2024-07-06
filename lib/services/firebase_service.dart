import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Task>> getTasks() async {
    var snapshot = await _firestore.collection('tasks').get();
    return snapshot.docs.map((doc) => Task.fromDocument(doc)).toList();
  }

  Future<void> addTask(Task task) {
    return _firestore.collection('tasks').doc(task.id).set(task.toMap());
  }

  Future<void> updateTask(Task task) {
    return _firestore.collection('tasks').doc(task.id).update(task.toMap());
  }

  Future<void> deleteTask(String id) {
    return _firestore.collection('tasks').doc(id).delete();
  }
}
