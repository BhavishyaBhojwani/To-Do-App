import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Add Task', style: TextStyle(fontSize: 14.sp)),
          ),
          body: Padding(
            padding: EdgeInsets.all(4.w),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(labelText: 'Title', labelStyle: TextStyle(fontSize: 12.sp)),
                  ),
                  SizedBox(height: 2.h),
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(labelText: 'Description', labelStyle: TextStyle(fontSize: 12.sp)),
                  ),
                  SizedBox(height: 2.h),
                  TextField(
                    controller: _priorityController,
                    decoration: InputDecoration(labelText: 'Priority Level (1-3)', labelStyle: TextStyle(fontSize: 12.sp)),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 2.h),
                  TextField(
                    controller: _dueDateController,
                    decoration: InputDecoration(labelText: 'Due Date (dd-MM-yyyy)', labelStyle: TextStyle(fontSize: 12.sp)),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        _dueDateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
                      }
                    },
                  ),
                  SizedBox(height: 4.h),
                  ElevatedButton(
                    onPressed: () {
                      var newTask = Task(
                        id: DateTime.now().toString(),
                        title: _titleController.text,
                        description: _descriptionController.text,
                        priorityLevel: int.parse(_priorityController.text),
                        dueDate: Timestamp.fromDate(DateFormat('dd-MM-yyyy').parse(_dueDateController.text)),
                      );
                      _taskController.addTask(newTask);
                      Get.back();
                    },
                    child: Text('Add Task', style: TextStyle(fontSize: 12.sp)),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
