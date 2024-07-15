import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/utils/themes.dart';
import 'package:flutter_application_1/views/splash_view.dart';
import 'package:get/get.dart';
import 'views/task_list_view.dart';
import 'views/add_task_view.dart';
import 'views/edit_task_view.dart';
import 'views/view_task.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: lightTheme, // initial theme
      darkTheme: darkTheme,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: const AnimatedSplashScreenPage(),
      getPages: [
        GetPage(name: '/task-list', page: () => TaskListView()),
        GetPage(name: '/add-task', page: () => AddTaskView()),
        GetPage(name: '/edit-task', page: () => EditTaskView()),
        GetPage(name: '/view-task', page: () => ViewTaskScreen()),
      ],
    );
  }
}
