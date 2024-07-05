import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import '../controllers/task_controller.dart';
import '../models/task_model.dart';

class AddTaskView extends StatelessWidget {
  final TaskController _taskController = Get.find();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priorityController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task', style: TextStyle(fontSize: 14.sp)),
      ),
      body: Padding(
        padding: EdgeInsets.all(4.w),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(fontSize: 12.sp),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
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
                if (value == null || value.isEmpty) {
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
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a priority level';
                } else if (int.tryParse(value) == null) {
                  return 'Priority level must be a number';
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
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  _dueDateController.text =
                      DateFormat('dd-MM-yyyy').format(pickedDate);
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a due date';
                }
                return null;
              },
            ),
            SizedBox(height: 4.h),
            ElevatedButton(
              onPressed: () {
                if (validateForm()) {
                  var newTask = Task(
                    id: DateTime.now().toString(),
                    title: _titleController.text,
                    description: _descriptionController.text,
                    priorityLevel: int.parse(_priorityController.text),
                    dueDate: Timestamp.fromDate(DateFormat('dd-MM-yyyy')
                        .parse(_dueDateController.text)),
                  );
                  _taskController.addTask(newTask);
                  showSuccessSnackbar();
                  Get.offAllNamed('/task-list'); // Navigate to task list view
                } else {
                  showFormSnackbar();
                }
              },
              child: Text('Add Task', style: TextStyle(fontSize: 12.sp)),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool validateForm() {
    return _titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _priorityController.text.isNotEmpty &&
        _dueDateController.text.isNotEmpty &&
        int.tryParse(_priorityController.text) != null;
  }

  void showFormSnackbar() {
    if (_titleController.text.isEmpty) {
      Get.snackbar(
        'Empty Field',
        'Please enter a title',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } else if (_descriptionController.text.isEmpty) {
      Get.snackbar(
        'Empty Field',
        'Please enter a description',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } else if (_priorityController.text.isEmpty) {
      Get.snackbar(
        'Empty Field',
        'Please enter a priority level',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } else if (int.tryParse(_priorityController.text) == null) {
      Get.snackbar(
        'Invalid Input',
        'Priority level must be a number',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } else if (_dueDateController.text.isEmpty) {
      Get.snackbar(
        'Empty Field',
        'Please select a due date',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void showSuccessSnackbar() {
    Get.snackbar(
      'Task Added',
      'The task has been added successfully.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}
