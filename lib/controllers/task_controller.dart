import 'package:get/get.dart';
import '../models/task_model.dart';
import '../services/firebase_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;

class TaskController extends GetxController {
  var tasks = <Task>[].obs;
  var searchQuery = ''.obs;
  var isLoading = true.obs;
  

  final FirebaseService _firebaseService = FirebaseService();
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void onInit() {
    tzdata.initializeTimeZones();
    fetchTasks();
    super.onInit();
  }

  void fetchTasks() async {
    isLoading.value = true;
    var fetchedTasks = await _firebaseService.getTasks();
    tasks.assignAll(fetchedTasks);
    isLoading.value = false;

    // Schedule notifications for tasks that are not completed and are due soon
    scheduleNotificationsForDueTasks();
  }

  void addTask(Task task) async {
    await _firebaseService.addTask(task);
    tasks.add(task);

    // Show notification for adding task
    _flutterLocalNotificationsPlugin.show(
      task.id.hashCode,
      'Task Added',
      'The task "${task.title}" has been added successfully.',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'task_channel',
          'Task Notifications',
          importance: Importance.max,
          enableVibration: true,
          priority: Priority.high,
        ),
      ),
    );

    // Schedule notification for this task if it is not completed and is due soon
    if (!task.isCompleted) {
      scheduleNotificationForTask(task);
    }
  }

  void updateTask(Task task) async {
    await _firebaseService.updateTask(task);
    var index = tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      tasks[index] = task; // Update local task list

      // Show notification for updating task
      _flutterLocalNotificationsPlugin.show(
        task.id.hashCode,
        'Task Updated',
        'The task "${task.title}" has been updated successfully.',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'task_channel',
            'Task Notifications',
            importance: Importance.max,
            enableVibration: true,
            priority: Priority.high,
          ),
        ),
      );

      // Reschedule notification if task is not completed and is due soon
      if (!task.isCompleted) {
        scheduleNotificationForTask(task);
      } else {
        cancelNotification(task.id);
      }
    }
  }

  void deleteTask(String id) async {
    await _firebaseService.deleteTask(id);
    tasks.removeWhere((task) => task.id == id);
    _flutterLocalNotificationsPlugin.cancel(id.hashCode);
  }

  void updateTaskCompletion(String id, bool isCompleted) async {
    var index = tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      tasks[index].isCompleted = isCompleted;
      await _firebaseService.updateTask(tasks[index]);

      // Cancel or reschedule notification based on task completion status
      if (isCompleted) {
        cancelNotification(id);
      } else {
        scheduleNotificationForTask(tasks[index]);
      }
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
        return task.title.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
            task.description.toLowerCase().contains(searchQuery.value.toLowerCase());
      }).toList();
    }
  }

  void scheduleNotificationsForDueTasks() {
    for (var task in tasks) {
      if (!task.isCompleted) {
        scheduleNotificationForTask(task);
      }
    }
  }

  void scheduleNotificationForTask(Task task) {
    // Calculate notification time (e.g., 15 minutes before due date)
    DateTime dueDateTime = task.dueDate.toDate();
    DateTime notificationTime = dueDateTime.subtract(Duration(minutes: 15));

    // Schedule notification
    _flutterLocalNotificationsPlugin.zonedSchedule(
      task.id.hashCode,
      'Task Reminder',
      'Reminder for task "${task.title}"',
      tz.TZDateTime.from(notificationTime, tz.local),
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
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  void cancelNotification(String id) {
    _flutterLocalNotificationsPlugin.cancel(id.hashCode);
  }
}
