import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/task_controller.dart';
import '../widgets/custom_textfield.dart';
import '../models/task.dart';

class AddTaskScreen extends StatelessWidget {
  final TaskController taskController = Get.find();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  AddTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Task',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextField(
              controller: titleController,
              label: 'Title',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: descriptionController,
              label: 'Description',
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ButtonStyle(
                  foregroundColor: const WidgetStatePropertyAll(Colors.white),
                  backgroundColor: const WidgetStatePropertyAll(Colors.green),
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)))),
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    descriptionController.text.isNotEmpty) {
                  final task = Task(
                    title: titleController.text,
                    description: descriptionController.text,
                  );
                  taskController.addTask(task);
                  // Clear the text fields
                  titleController.clear();
                  descriptionController.clear();
                  Get.back();
                } else {
                  Get.snackbar(
                    'Error',
                    'All fields are required',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              },
              child: const Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}
