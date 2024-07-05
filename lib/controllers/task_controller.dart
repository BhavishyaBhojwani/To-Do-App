import 'package:get/get.dart';
import '../models/task_model.dart';
import '../services/firebase_service.dart';

class TaskController extends GetxController {
  var tasks = <Task>[].obs;
  var searchQuery = ''.obs;
  var isLoading = true.obs; // Add isLoading state

  final FirebaseService _firebaseService = FirebaseService();

  @override
  void onInit() {
    fetchTasks();
    super.onInit();
  }

  void fetchTasks() async {
    isLoading.value = true; // Set loading state
    var fetchedTasks = await _firebaseService.getTasks();
    tasks.assignAll(fetchedTasks);
    isLoading.value = false; // Set loading state
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

  void sortByPriority() {
    tasks.sort((a, b) => a.priorityLevel.compareTo(b.priorityLevel));
  }

  void sortByDueDate() {
    tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }

  void sortByCreationDate() {
    tasks.sort((a, b) =>
        a.id.compareTo(b.id)); // Assuming ID is based on creation date
  }

  List<Task> get filteredTasks {
    if (searchQuery.value.isEmpty) {
      return tasks;
    } else {
      return tasks.where((task) {
        return task.title
                .toLowerCase()
                .contains(searchQuery.value.toLowerCase()) ||
            task.description
                .toLowerCase()
                .contains(searchQuery.value.toLowerCase());
      }).toList();
    }
  }
}