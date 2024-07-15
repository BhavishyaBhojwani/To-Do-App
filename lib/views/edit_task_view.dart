import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import '../controllers/task_controller.dart';
import '../controllers/theme_controller.dart'; // Import ThemeController
import '../models/task_model.dart';
class EditTaskView extends StatelessWidget {
  final TaskController _taskController = Get.find();
  final ThemeController _themeController = Get.find(); // Retrieve ThemeController instance

  @override
  Widget build(BuildContext context) {
    final Task task = Get.arguments;

    final TextEditingController _titleController =
        TextEditingController(text: task.title);
    final TextEditingController _descriptionController =
        TextEditingController(text: task.description);
    final TextEditingController _priorityController =
        TextEditingController(text: task.priorityLevel.toString());
    final TextEditingController _dueDateController = TextEditingController(
        text: DateFormat('dd-MM-yyyy').format(task.dueDate.toDate()));

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Task', style: TextStyle(fontSize: 14.sp)),
      ),
      body: Padding(
        padding: EdgeInsets.all(4.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(fontSize: 12.sp),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 2.h),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(fontSize: 12.sp),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 2.h),
              TextFormField(
                controller: _priorityController,
                decoration: InputDecoration(
                  labelText: 'Priority Level (1-3)',
                  labelStyle: TextStyle(fontSize: 12.sp),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a priority level';
                  }
                  return null;
                },
              ),
              SizedBox(height: 2.h),
              TextFormField(
                controller: _dueDateController,
                decoration: InputDecoration(
                  labelText: 'Due Date (dd-MM-yyyy)',
                  labelStyle: TextStyle(fontSize: 12.sp),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: task.dueDate.toDate(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    _dueDateController.text =
                        DateFormat('dd-MM-yyyy').format(pickedDate);
                  }
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please select a due date';
                  }
                  return null;
                },
              ),
              SizedBox(height: 4.h),
              ElevatedButton(
                onPressed: () {
                  if (_titleController.text.isEmpty ||
                      _descriptionController.text.isEmpty ||
                      _priorityController.text.isEmpty ||
                      _dueDateController.text.isEmpty) {
                    // Show error snackbar if any field is empty
                    Get.snackbar(
                      'Validation Error',
                      'Please fill in all fields.',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                      duration: Duration(seconds: 2),
                    );
                    return;
                  }

                  var updatedTask = Task(
                    id: task.id,
                    title: _titleController.text,
                    description: _descriptionController.text,
                    priorityLevel: int.parse(_priorityController.text),
                    dueDate: Timestamp.fromDate(
                        DateFormat('dd-MM-yyyy').parse(_dueDateController.text)),
                    isCompleted: task.isCompleted,
                  );
                  _taskController.updateTask(updatedTask);

                  // Show success snackbar
                  Get.snackbar(
                    'Task Updated',
                    'Your task has been successfully updated.',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                    duration: Duration(seconds: 2),
                  );

                  // Navigate to task list view after showing snackbar
                  Future.delayed(Duration(seconds: 2), () {
                    Get.offAllNamed('/task-list');
                  });
                },
                child: Text('Update Task', style: TextStyle(fontSize: 12.sp)),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h), backgroundColor: _themeController.isDarkMode.value ? Colors.teal : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}