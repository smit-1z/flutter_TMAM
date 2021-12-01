import 'package:authentification/Controllers/firestore_controller.dart';
import 'package:authentification/Controllers/user_controller.dart';
import 'package:authentification/create_task.dart';
import 'package:authentification/models/task_model.dart';
import 'package:authentification/models/user_model.dart';
import 'package:authentification/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blue,
      ),
      home: MyApp1(),
    ));

class MyApp1 extends StatefulWidget {
  final String? value;

  MyApp1({Key? key, this.value}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp1> {
  List todos = [];

  bool isloggedin = true;
  UserModel? userModelList;

  bool isLoading = false;

  Future getTodoList() async {
    setState(() {
      isLoading = true;
    });
    UserController userController = UserController();
    userModelList = await userController.getUserList(context);

    // print(userModelList!.toMap());

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    todos.add("item!");
    todos.add("item2");
    todos.add("item3");
    todos.add("item4");

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      getTodoList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          onPressed: () async {
            bool isTrue = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainPage()),
            );
            print(isTrue);
            if (isTrue) {
              getTodoList();
            }
          },
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text("Todo"),
        ),
        body: userModelList == null
            ? Container(
                child: Center(
                  child: Text("No Todos"),
                ),
              )
            : todoView());
  }

  Widget todoView() {
    return userModelList!.taskList!.length == 0
        ? Center(
            child: Container(
            child: Text("No Todos"),
          ))
        : todoListView();
  }

  Widget todoListView() {
    return ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: userModelList!.taskList!.length,
        itemBuilder: (BuildContext context, int index) {
          return todoItemView(userModelList!.taskList![index], userModelList!);
        });
  }

  Widget todoItemView(TaskModels taskModels, UserModel userModel) {
    return Container(
      child: Card(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                "${taskModels.task ?? ""}",
                style: TextStyle(color: Colors.black),
              )),
              InkWell(
                  onTap: () async {
                    bool? isTrue = await showDialog(
                        context: context,
                        builder: (context) {
                          return CupertinoAlertDialog(
                            title: Text("Delete"),
                            content: Text("Are you sure you want to delete?"),
                            actions: [
                              CupertinoButton(
                                  child: Text("No"),
                                  onPressed: () =>
                                      Navigator.pop(context, false)),
                              CupertinoButton(
                                  child: Text("Yes"),
                                  onPressed: () => Navigator.pop(context, true))
                            ],
                          );
                        });
                    if (isTrue == true) {
                      await FirestoreController()
                          .firestore
                          .collection(USERS_COLLECTION)
                          .doc(userModel.id)
                          .update({
                        "tasks": FieldValue.arrayRemove([taskModels.toMap()])
                      });
                      userModelList!.taskList!.remove(taskModels);



                      setState(() {});
                    }
                  },
                  child: Icon(Icons.delete))
            ],
          ),
        ),
      ),
    );
  }

/*
  createTodos() {
    DocumentReference documentReference =
    Firestore.instance.collection("MyTodos").document(todoTitle);

    //Map
    Map<String, String> todos = {"todoTitle": todoTitle};

    documentReference.setData(todos).whenComplete(() {
      print("$todoTitle created");
    });
  }

  deleteTodos(item) {
    DocumentReference documentReference =
    Firestore.instance.collection("MyTodos").document(item);

    documentReference.delete().whenComplete(() {
      print("$item deleted");
    });
  }

 */
  @override
  Widget build2(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("todos"),
      ),
      body: ListView.builder(
          itemCount: todos.length,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
                key: Key(todos[index]),
                child: Card(
                  child: ListTile(
                    title: Text(todos[index]),
                  ),
                ));
          }),
    );
  }

/*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("todos"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  title: Text("Add Todolist"),
                  content: TextField(
                    onChanged: (String value) {
                      todoTitle = value;
                    },
                  ),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () {
                          createTodos();

                          Navigator.of(context).pop();
                        },
                        child: Text("Add"))
                  ],
                );
              });
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: StreamBuilder(
          stream: Firestore.instance.collection("MyTodos").snapshots(),
          builder: (context, snapshots) {
            if (snapshots.hasData) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshots.data.documents.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot documentSnapshot =
                    snapshots.data.documents[index];
                    return Dismissible(
                        onDismissed: (direction) {
                          deleteTodos(documentSnapshot["todoTitle"]);
                        },
                        key: Key(documentSnapshot["todoTitle"]),
                        child: Card(
                          elevation: 4,
                          margin: EdgeInsets.all(8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: ListTile(
                            title: Text(documentSnapshot["todoTitle"]),
                            trailing: IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  deleteTodos(documentSnapshot["todoTitle"]);
                                }),
                          ),
                        ));
                  });
            } else {
              return Align(
                alignment: FractionalOffset.bottomCenter,
                child: CircularProgressIndicator(),
              );
            }
          }),
    );


  }

 */
}
