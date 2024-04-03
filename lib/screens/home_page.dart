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
                  onTap: () {
                    titleController.text = todoList[index].title;
                    descController.text = todoList[index].desc;
                    showModalBottomSheet(
                        context: context, 
                        builder: (_) {
                          return customBottomSheet(isUpdate: true,
                              updateIndex: todoList[index].id,
                          );
                        },
                    
                    );
                  },
                  title: Text(todoList[index].title),
                  subtitle: Text(todoList[index].desc),
                  trailing: InkWell(
                    onTap: () {
                      db!.deleteTodo(todoList[index].id);
                      getAllTodoList();
                    },
                      child: const Icon(Icons.delete, color: Colors.red)),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          titleController.clear();
          descController.clear();

          showModalBottomSheet(
            context: context,
            builder: (_) {
              return customBottomSheet();
            },
          );
         
        },
        child: const Icon(Icons.add),
      ),
    );
  }
  
  ///////// customBottomSheet
  
  Widget customBottomSheet({bool isUpdate = false,int updateIndex = -1}){
    return SizedBox(
      height: 600,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text(isUpdate ? 'Update Todo' : 'Add Todo',
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 15),
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
                      if (!isUpdate) {
                        db!.addTodo(
                          todoModel: TodoModel(title: titleController.text, desc: descController.text),
                        );
                      } else{
                        db!.updateTodo(TodoModel(
                          id: updateIndex!,
                          title: titleController.text,
                          desc: descController.text,
                        ));
                        // titleController.clear();
                        // descController.clear();
                      }
                      getAllTodoList();
                      Navigator.pop(context);
                     
                    },
                    child: Text(isUpdate ? 'Update Todo' : 'Add Todo')),
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
      ),
    );
  }
}
