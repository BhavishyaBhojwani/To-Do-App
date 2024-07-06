import 'package:get/get.dart';
import '../models/task_model.dart';
import '../services/firebase_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzData;

class TaskController extends GetxController {
  var tasks = <Task>[].obs;
  var searchQuery = ''.obs;
  var isLoading = true.obs;

  final FirebaseService _firebaseService = FirebaseService();
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void onInit() {
    tzData.initializeTimeZones();
    fetchTasks();
    super.onInit();
  }

  void fetchTasks() async {
    isLoading.value = true;
    var fetchedTasks = await _firebaseService.getTasks();
    tasks.assignAll(fetchedTasks);
    isLoading.value = false;

    // Schedule notifications for tasks
    tasks.forEach((task) {
      _scheduleNotification(task);
    });
  }

  void addTask(Task task) {
    _firebaseService.addTask(task);
    tasks.add(task);
    _scheduleNotification(task);
  }

  void updateTask(Task task) {
    _firebaseService.updateTask(task);
    var index = tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      tasks[index] = task;
      _scheduleNotification(task);
    }
  }

  void deleteTask(String id) {
    _firebaseService.deleteTask(id);
    tasks.removeWhere((task) => task.id == id);
    _flutterLocalNotificationsPlugin.cancel(id.hashCode);
  }

  void updateTaskCompletion(String id, bool isCompleted) {
    var index = tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      tasks[index].isCompleted = isCompleted;
      _firebaseService.updateTask(tasks[index]);
    }
  }

  void sortByPriority() {
    tasks.sort((a, b) => a.priorityLevel.compareTo(b.priorityLevel));
  }

  void sortByDueDate() {
    tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }

  void sortByCreationDate() {
    tasks.sort((a, b) => a.id.compareTo(b.id));
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

  void _scheduleNotification(Task task) {
    // Check if task is already completed
    if (task.isCompleted) {
      return; // Skip scheduling notification for completed tasks
    }

    // Convert Firebase Timestamp to DateTime
    DateTime dueDateTime = task.dueDate.toDate();

    // Calculate notification time based on task's due date
    final Duration timeDifference = dueDateTime.difference(DateTime.now());
    final Duration offset =
        const Duration(hours: 2); 

    if (timeDifference > offset) {
      final tz.TZDateTime scheduledDate =
          tz.TZDateTime.from(dueDateTime.subtract(offset), tz.local);

      _flutterLocalNotificationsPlugin.zonedSchedule(
        task.id.hashCode,
        'Task Due Reminder',
        'Your task "${task.title}" is due soon!',
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'task_channel',
            'Task Notifications',
            importance: Importance.max,
            enableVibration: true,
            priority: Priority.high,
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }
}
