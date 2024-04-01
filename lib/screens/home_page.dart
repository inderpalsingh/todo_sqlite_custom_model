import 'package:flutter/material.dart';
import 'package:todo_sqlite/db_connections/connection.dart';
import 'package:todo_sqlite/models/todo_model.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DbAppConnection? db;

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  List<TodoModel> todoList = [];

  @override
  void initState() {
    db = DbAppConnection.db; // accessing the database class object
    super.initState();
    getAllTodoList();
  }

  void getAllTodoList() async {
    todoList = await db!.fetchAllTodo();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Sqlite'),
      ),
      body: todoList.isEmpty
          ? const Center(child: Text('No List'))
          : ListView.builder(
              itemCount: todoList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(todoList[index].title),
                  subtitle: Text(todoList[index].desc),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          titleController.clear();
          descController.clear();

          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text(
                      'Add Todo',
                      style: TextStyle(fontSize: 15),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), hintText: 'Enter task'),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: descController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), hintText: 'Enter desc'),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              if (titleController.text.isNotEmpty &&  descController.text.isNotEmpty) {
                                db!.addTodo(
                                  todoModel: TodoModel(title: titleController.text, desc: descController.text),
                                );
                              }

                              Navigator.pop(context);
                              setState(() {
                                getAllTodoList();
                              });
                            },
                            child: const Text('Save')),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              setState(() {});
                            },
                            child: const Text('Cancel')),
                      ],
                    )
                  ],
                ),
              );
            },
          );
          // db!.addTodo();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
