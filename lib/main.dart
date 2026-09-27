import 'package:flutter/material.dart';

void main() {
  // Entry point of the app
  runApp(const MyApp());
}

class Task {
  String text;
  bool isCompleted;

  Task({required this.text, this.isCompleted = false});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Sets the home screen of the app
      home: const HomeScreen(),

      // Removes debug banner
      debugShowCheckedModeBanner: false,

      // Sets the app theme color
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.white,
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // List to store tasks
  final List<Task> todoList = [];

  // Function to add a new task
  void addTask(String taskText) {
    setState(() {
      todoList.add(Task(text: taskText));
    });
  }

  // Function to update an existing task
  void updateTask(String taskText, int index) {
    setState(() {
      todoList[index].text = taskText;
    });
  }

  // Function to delete a task
  void deleteItem(int index) {
    setState(() {
      todoList.removeAt(index);
    });
  }

  // Function to show the floating window task form
  void _showTaskForm({int? index}) {
    final TextEditingController controller = TextEditingController(
      text: index != null ? todoList[index].text : '',
    );

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(index != null ? 'Edit Task' : 'New Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: 'Enter task...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: 3,
                minLines: 1,
                autofocus: true,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  final text = controller.text.trim();
                  if (text.isNotEmpty) {
                    if (index != null) {
                      updateTask(text, index);
                    } else {
                      addTask(text);
                    }
                    Navigator.pop(dialogContext);
                  }
                },
                child: const Text(
                  'Confirm',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Todo Application",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.indigo),
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                  onPressed: () => Navigator.pop(context),
                  tooltip: 'Slide back sidebar',
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "About",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "A simple todo list application made with flutter.",
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: todoList.isEmpty
          ? const Center(
              child: Text(
                "",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: todoList.length,
              itemBuilder: (context, index) {
                final task = todoList[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: task.isCompleted,
                          activeColor: Colors.indigo,
                          onChanged: (bool? value) {
                            setState(() {
                              task.isCompleted = value ?? false;
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            task.text,
                            style: TextStyle(
                              fontSize: 16,
                              decoration: task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: task.isCompleted
                                  ? Colors.grey
                                  : Colors.black87,
                            ),
                            softWrap: true,
                          ),
                        ),
                        PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'edit') {
                              _showTaskForm(index: index);
                            } else if (value == 'remove') {
                              deleteItem(index);
                            }
                          },
                          itemBuilder: (BuildContext context) => [
                            const PopupMenuItem<String>(
                              value: 'edit',
                              child: Text('Edit'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'remove',
                              child: Text('Remove'),
                            ),
                          ],
                          icon: const Icon(Icons.more_vert),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        onPressed: () => _showTaskForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
