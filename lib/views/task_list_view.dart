import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import '../controllers/task_controller.dart';
import '../widgets/task_tile.dart';
import '../utils/my_colors.dart';

class TaskListView extends StatelessWidget {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'To-Do List',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Get.toNamed('/add-task');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AnimSearchBar(
              width: MediaQuery.of(context).size.width - 32,
              textController: textController,
              onSuffixTap: () {
                textController.clear();
                _taskController.searchQuery.value = '';
              },
              onSubmitted: (text) {
                _taskController.searchQuery.value = text;
              },
              helpText: 'Search tasks...',
              suffixIcon: Icon(Icons.clear),
              animationDurationInMilli: 400,
            ),
          ),
          Expanded(
            child: Obx(() {
              final filteredTasks = _taskController.filteredTasks;
              if (filteredTasks.isEmpty) {
                return Center(child: Text('No tasks yet!'));
              }
              return ListView.builder(
                itemCount: filteredTasks.length,
                itemBuilder: (context, index) {
                  return TaskTile(task: filteredTasks[index], index: index);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
