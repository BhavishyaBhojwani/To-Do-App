import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/task_controller.dart';
import '../models/task_model.dart';

class EditTaskView extends StatelessWidget {
  final TaskController _taskController = Get.find();

  @override
  Widget build(BuildContext context) {
    final Task task = Get.arguments;

    final TextEditingController _titleController = TextEditingController(text: task.title);
    final TextEditingController _descriptionController = TextEditingController(text: task.description);
    final TextEditingController _priorityController = TextEditingController(text: task.priorityLevel.toString());
    final TextEditingController _dueDateController = TextEditingController(text: DateFormat('dd-MM-yyyy').format(task.dueDate.toDate()));

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _priorityController,
              decoration: InputDecoration(labelText: 'Priority Level (1-3)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _dueDateController,
              decoration: InputDecoration(labelText: 'Due Date (dd-MM-yyyy)'),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: task.dueDate.toDate(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  _dueDateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
                }
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                var updatedTask = Task(
                  id: task.id,
                  title: _titleController.text,
                  description: _descriptionController.text,
                  priorityLevel: int.parse(_priorityController.text),
                  dueDate: Timestamp.fromDate(DateFormat('dd-MM-yyyy').parse(_dueDateController.text)),
                  isCompleted: task.isCompleted,
                );
                _taskController.updateTask(updatedTask);
                Get.back();
              },
              child: Text('Update Task'),
            ),
          ],
        ),
      ),
    );
  }
}
