import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:sizer/sizer.dart';
import '../controllers/task_controller.dart';
import '../widgets/task_tile.dart';

class TaskListView extends StatelessWidget {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Sizer(
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
                child: Image.asset(
                  'assets/images/hi.png',
                  width: 14.w,
                  height: 10.h,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              children: [
                AnimSearchBar(
                  width: 90.w,
                  textController: textController,
                  onSuffixTap: () {
                    textController.clear();
                    _taskController.searchQuery.value = '';
                  },
                  onSubmitted: (text) {
                    _taskController.searchQuery.value = text;
                  },
                  helpText: 'Search tasks...',
                  suffixIcon: Icon(Icons.clear, size: 20.sp),
                  animationDurationInMilli: 250,
                ),
                SizedBox(height: 0.2.h),
                Expanded(
                  child: Obx(() {
                    if (_taskController.isLoading.value) {
                      // Show a loader while data is being fetched
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
    );
  }
}
