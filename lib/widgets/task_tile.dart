import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/task_controller.dart';
import '../models/task_model.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final int index;

  TaskTile({required this.task, required this.index});

  @override
  Widget build(BuildContext context) {
    final TaskController _taskController = Get.find();
    final ValueNotifier<bool> isCompleted = ValueNotifier<bool>(task.isCompleted);

    String formatDate(Timestamp timestamp) {
      var date = timestamp.toDate();
      var formatter = DateFormat('dd-MM-yyyy');
      return formatter.format(date);
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), 
        side: BorderSide(color: Colors.grey[300]!), // Border color
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text((index + 1).toString()),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.description,
              style: TextStyle(fontSize: 14),
            ),
            Text(
              'Priority: ${task.priorityLevel}',
              style: TextStyle(fontSize: 14),
            ),
            Text(
              'Due Date: ${formatDate(task.dueDate)}',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                // Toggle task completion status
                isCompleted.value = !isCompleted.value;
                // Update completion status in Firebase or wherever it's stored
                _taskController.updateTaskCompletion(task.id, isCompleted.value);

                // Show snackbar if task is completed
                if (isCompleted.value) {
                  Get.snackbar(
                    'Task Completed',
                    'Great job! You completed the task.',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                }
              },
              child: ValueListenableBuilder<bool>(
                valueListenable: isCompleted,
                builder: (context, value, child) => Icon(
                  value ? Icons.check_circle : Icons.check_circle_outline,
                  color: value ? Colors.green : Colors.grey,
                ),
              ),
            ),
            SizedBox(width: 16),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Delete Task'),
                    content: Text('Do you want to delete this task?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Close the dialog
                        },
                        child: Text('No'),
                      ),
                      TextButton(
                        onPressed: () {
                          _taskController.deleteTask(task.id);
                          Navigator.pop(context); // Close the dialog
                          Get.snackbar(
                            'Task Deleted',
                            'The task has been deleted successfully.',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        },
                        child: Text('Yes'),
                      ),
                    ],
                  ),
                );
              },
              child: Icon(
                Icons.delete_outline,
                color: Colors.red,
              ),
            ),
          ],
        ),
        onTap: () {
          Get.toNamed('/edit-task', arguments: task);
        },
      ),
    );
  }
}
