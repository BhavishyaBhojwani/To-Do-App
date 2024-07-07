import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../controllers/task_controller.dart';
import '../widgets/task_tile.dart';

class TaskListView extends StatelessWidget {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController textController = TextEditingController();

  TaskListView() {
    textController.addListener(() {
      _taskController.searchQuery.value = textController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (textController.text.isNotEmpty) {
          textController.clear();
          _taskController.searchQuery.value = '';
          return false; // Prevent default back button behavior
        } else {
          return true; // Allow default back button behavior
        }
      },
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'ToDoBuddy',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.add, size: 25.sp),
                  onPressed: () {
                    Get.toNamed('/add-task');
                  },
                ),
                PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text('Sort by Priority'),
                      value: 'priority',
                    ),
                    PopupMenuItem(
                      child: Text('Sort by Due Date'),
                      value: 'dueDate',
                    ),
                    PopupMenuItem(
                      child: Text('Sort by Creation Date'),
                      value: 'creationDate',
                    ),
                  ],
                  onSelected: (value) {
                    switch (value) {
                      case 'priority':
                        _taskController.sortByPriority();
                        break;
                      case 'dueDate':
                        _taskController.sortByDueDate();
                        break;
                      case 'creationDate':
                        _taskController.sortByCreationDate();
                        break;
                    }
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(right: 2.w),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(
                            'Reminder',
                            style: TextStyle(fontSize: 14.sp),
                          ),
                          content: Text(
                            'Have you completed your tasks?',
                            style: TextStyle(fontSize: 12.sp),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'OK',
                                style: TextStyle(fontSize: 12.sp),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Image.asset(
                      'assets/images/hi.png',
                      width: 14.w,
                      height: 9.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    child: TextField(
                      controller: textController,
                      decoration: InputDecoration(
                        hintText: 'Search tasks...',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear, size: 20.sp),
                          onPressed: () {
                            textController.clear();
                            _taskController.searchQuery.value = '';
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28), // Adjust the radius for more curved sides
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28), // Adjust the radius for more curved sides
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28), // Adjust the radius for more curved sides
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 0.2.h),
                  Expanded(
                    child: Obx(() {
                      if (_taskController.isLoading.value) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        final filteredTasks = _taskController.filteredTasks;
                        if (filteredTasks.isEmpty) {
                          return Center(
                            child: Text(
                              'No tasks yet!',
                              style: TextStyle(fontSize: 14.sp),
                            ),
                          );
                        }
                        return SingleChildScrollView(
                          child: Column(
                            children: List.generate(filteredTasks.length, (index) {
                              return TaskTile(task: filteredTasks[index], index: index);
                            }),
                          ),
                        );
                      }
                    }),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
