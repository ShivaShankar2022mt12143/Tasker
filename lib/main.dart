import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final keyApplicationId = 'bJZU4f9u0TWKzexniq2ohv9SjnldA2N2koUcJOKZ';
  final keyClientKey = '9NOf0aYiwej3u9n0a3qRu8MZEnnnSjqzodaLdohS';
  final keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, autoSendSessionId: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const Home(title: 'Tasker'),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key, required this.title});

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    final query = QueryBuilder(ParseObject('Task_Details'))
      ..orderByDescending('createdAt'); // You can customize the query as needed

    final response = await query.query();

    if (response.success && response.results != null) {
      setState(() {
        tasks = response.results!.map((parseObject) => Task.fromParse(parseObject)).toList();
      });
    }
  }

  Future<void> addTask(String title, String description) async {
    final newTask = ParseObject('Task_Details')
      ..set<String>('title', title)
      ..set<String>('description', description);

    final response = await newTask.save();

    if (response.success) {
      fetchTasks(); // Refresh the task list after adding a new task
    }
  }

  Future<void> editTask(String objectId, String title, String description) async {
    final task = ParseObject('Task_Details')..objectId = objectId;
    task.set<String>('title', title);
    task.set<String>('description', description);

    final response = await task.save();

    if (response.success) {
      fetchTasks(); // Refresh the task list after editing a task
    }
  }

  Future<void> deleteTask(String objectId) async {
    final task = ParseObject('Task_Details')..objectId = objectId;

    final response = await task.delete();

    if (response.success) {
      fetchTasks(); // Refresh the task list after deleting a task
    }
  }

  void viewTaskDetails(Task task) {
    // Navigate to a new screen to view task details
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TaskDetailsScreen(task: task),
      ),
    );
  }

  void editTaskDetails(Task task) {
    // Show a dialog for editing task details
    showDialog(
      context: context,
      builder: (context) {
        return EditTaskDialog(editTask: editTask, task: task);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              left: 8.0,
              right: 8.0,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.lightBlue[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                title: Text(
                  task.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  task.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        editTaskDetails(task);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        deleteTask(task.objectId);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show a dialog to add a new task
          showDialog(
            context: context,
            builder: (context) {
              return AddTaskDialog(addTask: addTask);
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class Task {
  final String objectId;
  final String title;
  final String description;

  Task({required this.objectId, required this.title, required this.description});

  factory Task.fromParse(ParseObject parseObject) {
    return Task(
      objectId: parseObject.objectId!,
      title: parseObject.get('title'),
      description: parseObject.get('description'),
    );
  }
}

class AddTaskDialog extends StatefulWidget {
  final Function(String, String) addTask;

  AddTaskDialog({required this.addTask});

  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add New Task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(labelText: 'Description'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.addTask(titleController.text, descriptionController.text);
            Navigator.of(context).pop();
          },
          child: Text('Add'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }
}

class EditTaskDialog extends StatefulWidget {
  final Function(String, String, String) editTask;
  final Task task;

  EditTaskDialog({required this.editTask, required this.task});

  @override
  _EditTaskDialogState createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<EditTaskDialog> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.task.title;
    descriptionController.text = widget.task.description;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(labelText: 'Description'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.editTask(widget.task.objectId, titleController.text, descriptionController.text);
            Navigator.of(context).pop();
          },
          child: Text('Save'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }
}

class TaskDetailsScreen extends StatelessWidget {
  final Task task;

  TaskDetailsScreen({required this.task});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Task Details'),
        backgroundColor: colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title: ${task.title}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Description: ${task.description}',
              style: TextStyle(
                fontSize: 16,
                color: colorScheme.onBackground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

