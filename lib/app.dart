import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/view_task.dart';
import 'package:get/get.dart';
import 'views/task_list_view.dart';
import 'views/add_task_view.dart';
import 'views/edit_task_view.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return GetMaterialApp(
      debugShowCheckedModeBanner:false,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => TaskListView()),
        GetPage(name: '/add-task', page: () => AddTaskView()),
        GetPage(name: '/edit-task', page: () => EditTaskView()),    
        GetPage(name: '/view-task', page: () => ViewTaskScreen()), // Add this line

      ],
    );
  }
}
