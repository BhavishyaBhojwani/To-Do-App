import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import '../models/task_model.dart';

class ViewTaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Task task = Get.arguments;
    
     String formatCreatedAt(String id) {
      var timestamp = DateTime.parse(id); // Convert string to DateTime
      var formatter = DateFormat('dd-MM-yyyy');
      return formatter.format(timestamp);
    }

    String formatDate(Timestamp timestamp) {
      var date = timestamp.toDate();
      var formatter = DateFormat('dd-MM-yyyy');
      return formatter.format(date);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'View Task',
          style: TextStyle(fontSize: 18.sp),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 2.h),
            Text(
              task.description,
              style: TextStyle(fontSize: 14.sp),
            ),
            SizedBox(height: 2.h),
            Text(
              'Priority: ${task.priorityLevel}',
              style: TextStyle(fontSize: 14.sp),
            ),
            SizedBox(height: 2.h),
            Text(
              'Due Date: ${formatDate(task.dueDate)}',
              style: TextStyle(fontSize: 14.sp),
            ),
            SizedBox(height: 2.h),
            Text(
              'Created At: ${formatCreatedAt(task.id)}',
              style: TextStyle(fontSize: 14.sp),
            ),
          ],
        ),
      ),
    );
  }
}
