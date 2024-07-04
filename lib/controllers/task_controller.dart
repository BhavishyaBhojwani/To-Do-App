import 'package:get/get.dart';
import '../models/task_model.dart';
import '../services/firebase_service.dart';

class TaskController extends GetxController {
  var tasks = <Task>[].obs;
  var searchQuery = ''.obs;

  final FirebaseService _firebaseService = FirebaseService();

  @override
  void onInit() {
    fetchTasks();
    super.onInit();
  }

  void fetchTasks() async {
    var fetchedTasks = await _firebaseService.getTasks();
    tasks.assignAll(fetchedTasks);
  }

  void addTask(Task task) {
    _firebaseService.addTask(task);
    tasks.add(task);
  }

  void updateTask(Task task) {
    _firebaseService.updateTask(task);
    var index = tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      tasks[index] = task;
    }
  }

  void deleteTask(String id) {
    _firebaseService.deleteTask(id);
    tasks.removeWhere((task) => task.id == id);
  }

  void updateTaskCompletion(String id, bool isCompleted) {
    var index = tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      tasks[index].isCompleted = isCompleted;
      _firebaseService.updateTask(tasks[index]); // Update task in Firebase
    }
  }

  List<Task> get filteredTasks {
    if (searchQuery.value.isEmpty) {
      return tasks;
    } else {
      return tasks.where((task) {
        return task.title.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
            task.description.toLowerCase().contains(searchQuery.value.toLowerCase());
      }).toList();
    }
  }
}
