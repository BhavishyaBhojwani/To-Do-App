import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
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

    String formatCreatedAt(String id) {
      // Assuming your id is a timestamp in string format
      var timestamp = DateTime.parse(id); // Convert string to DateTime
      var formatter = DateFormat('dd-MM-yyyy');
      return formatter.format(timestamp);
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(color: Colors.grey[300]!), // Border color
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          leading: CircleAvatar(
            child: Text(
              (index + 1).toString(),
              style: TextStyle(fontSize: 12.sp),
            ),
          ),
          title: Text(
            task.title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 0.2.h),
              Text(
                task.description,
                style: TextStyle(fontSize: 10.sp),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              SizedBox(height: 0.2.h),
              Text(
                'Priority: ${task.priorityLevel}',
                style: TextStyle(fontSize: 10.sp),
              ),
              SizedBox(height: 0.2.h),
              Text(
                'Due Date: ${formatDate(task.dueDate)}',
                style: TextStyle(fontSize: 10.sp),
              ),
              SizedBox(height: 0.2.h),
              Row(
                children: [
                  Text(
                    'Created At: ',
                    style: TextStyle(fontSize: 10.sp),
                  ),
                  Text(
                    '${formatCreatedAt(task.id)}',
                    style: TextStyle(fontSize: 10.sp),
                  ),
                ],
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
                    size: 20.sp,
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                        'Delete Task',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                      content: Text(
                        'Do you want to delete this task?',
                        style: TextStyle(fontSize: 12.sp),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Close the dialog
                          },
                          child: Text(
                            'No',
                            style: TextStyle(fontSize: 12.sp),
                          ),
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
                          child: Text(
                            'Yes',
                            style: TextStyle(fontSize: 12.sp),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                child: Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                  size: 20.sp,
                ),
              ),
            ],
          ),
          onTap: () {
            Get.toNamed('/edit-task', arguments: task);
          },
        ),
      ),
    );
  }
}
