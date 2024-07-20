import 'package:flutter/material.dart';
import 'package:myapp/screens/addOrEdit_screen.dart';
import 'package:myapp/services/api_service.dart';
import 'package:myapp/utils/snackbar_message.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List todoList = [];
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        fetchTodo();
      });
    });
  }

  void fetchTodo() async {
    todoList = await ApiService.getTodo();
    print(todoList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        title: Text('Todo List'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddEdit(screen: "Add", id: "")));
        },
        label: Text('Add Todo'),
      ),
      body: RefreshIndicator(
          onRefresh: () {
            return Future.delayed(Duration(seconds: 0), () async {
              todoList = await ApiService.getTodo();
              setState(() {});
            });
          },
          child: ListView.builder(
              itemCount: todoList.length,
              itemBuilder: (context, index) {
                final todo = todoList[index];
                final title = todo['title'];
                final description = todo['description'];
                final id = todo['_id'];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      title: Text(title),
                      subtitle: Text(description),
                      trailing: PopupMenuButton(
                          onSelected: (value) async {
                            if (value == "Edit") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AddEdit(screen: "Edit", id: id)));
                            } else {
                              bool status = await ApiService.deleteTodo(id: id);
                              if (status) {
                                SnackBarMessage.showSnackBar(context,
                                    'Deleted Successfully', Colors.red);
                                setState(() {
                                  todoList.removeAt(index);
                                });
                              } else {
                                SnackBarMessage.showSnackBar(
                                    context, 'Deletion Failed', Colors.orange);
                              }
                            }
                          },
                          icon: Icon(Icons.more_horiz),
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem(
                                value: 'Edit',
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.edit),
                                    SizedBox(width: 10),
                                    Text('Edit'),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'Delete',
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.delete),
                                    SizedBox(width: 10),
                                    Text('Delete'),
                                  ],
                                ),
                              ),
                            ];
                          }),
                    ),
                  ),
                );
              })),
    );
  }
}
