import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/task_controller.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TaskController taskController = Get.find();
  bool isDarkMode = Get.isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Dark Theme'),
              value: isDarkMode,
              onChanged: (value) {
                setState(() {
                  isDarkMode = value;
                });
                Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Get.snackbar(
                  'Clearing Cache',
                  'Cache cleared successfully',
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: Colors.grey[800],
                  colorText: Colors.white,
                );
                taskController.clearTasks(); 
              },
              child: const Text('Clear Cache'),
            ),
          ],
        ),
      ),
    );
  }
}
