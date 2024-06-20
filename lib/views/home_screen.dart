import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../controllers/task_controller.dart';
import '../widgets/task_card.dart';
import 'detail_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TaskController taskController = Get.put(TaskController());
  final TextEditingController searchController = TextEditingController();
  late stt.SpeechToText _speech;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Todo App',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Get.to(() => const SettingsScreen());
            },
          ),
        ],
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          Container(
            color: Colors.green,
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                taskController.searchTasks(value);
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search',
                suffixIcon: IconButton(
                  icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                  onPressed: () {
                    setState(() {
                      _isListening = !_isListening;
                    });
                    if (_isListening) {
                      startListening();
                    } else {
                      stopListening();
                    }
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Obx(() {
                return ListView.builder(
                  itemCount: taskController.filteredTaskList.length,
                  itemBuilder: (context, index) {
                    final task = taskController.filteredTaskList[index];
                    return TaskCard(
                      task: task,
                      onTap: () {
                        Get.to(() => DetailScreen(task: task));
                      },
                      onDelete: () {
                        taskController.deleteTask(task.id!);
                      },
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  void startListening() async {
    if (!_speech.isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) {},
        onError: (error) => print('Error: $error'),
      );

      if (available) {
        _speech.listen(
          onResult: (result) {
            setState(() {
              searchController.text = result.recognizedWords;
            });
          },
        );
      }
    }
  }

  void stopListening() {
    if (_speech.isListening) {
      _speech.stop();
    }
  }
}
