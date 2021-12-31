import 'package:flutter/material.dart';
import 'package:todolistcw1/model/todo.dart';
import 'package:todolistcw1/util/dbhelper.dart';
import 'package:todolistcw1/views/viewtodo.dart';

class TodoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TodoListState();
}

class TodoListState extends State {
  DbHelper helper = DbHelper();
  List<Todo> todos;

  @override
  Widget build(BuildContext context) {
    if (todos == null) {
      todos = List<Todo>();
      getData();
    }
    return Scaffold(
      backgroundColor: Color(0XFF0E1731),
      body: Padding(
        padding: const EdgeInsets.only(
            left: 15.0, right: 15.0, top: 20.0, bottom: 43.0),
        child: todoListItems(),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0XFFFF4600),
          onPressed: () {
            navigateToDetail(Todo('', 3, ''));
          },
          child: new Icon(
            Icons.add,
            size: 35.0,
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  ListView todoListItems() {
    return ListView.builder(
        padding: EdgeInsets.only(top: 10.0),
        itemCount: todos.length,
        itemBuilder: (BuildContext context, int position) {
          return Container(
            padding: EdgeInsets.only(bottom: 10.0),
            decoration: BoxDecoration(),
            child: Container(
              key: Key(todos[position].id.toString()),
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  color: getColor(todos[position].priority),
                  elevation: 0.0,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                    child: ListTile(
                      title: Container(
                        child: Text(
                          todos[position].title,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.0,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            validateDescription(todos[position].description),
                            style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 15.0,
                                color: Colors.white,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 5.0),
                                child: Text(
                                  'Date Created ' + todos[position].date,
                                  style: TextStyle(
                                      fontSize: 11.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      isThreeLine: true,
                      onTap: () {
                        debugPrint(
                            "Tapped on " + todos[position].id.toString());
                        navigateToDetail(todos[position]);
                      },
                    ),
                  )),
            ),
          );
        });
  }

  String validateDescription(String desc) {
    if (desc.length != 0) {
      return desc.length > 42 ? desc.substring(0, 42) + '...' : desc;
    }
    return '...';
  }

  void getData() {
    final dbFuture = helper.initalizeDb();
    dbFuture.then((result) {
      final todosFuture = helper.getTodos();
      todosFuture.then((result) {
        List<Todo> todoList = List<Todo>();
        for (int i = 0; i < result.length; i++) {
          todoList.add(Todo.fromObject(result[i]));
          debugPrint(todoList[i].title);
        }
        setState(() {
          todos = todoList;
        });
        debugPrint("Items: " + todos.length.toString());
      });
    });
  }

  Color getColor(int priority) {
    switch (priority) {
      case 1:
        return Color(0XFFFF0051);
        break;
      case 2:
        return Color(0XFFFF8000);
        break;
      case 3:
        return Color(0XFFFFA200);
        break;

      default:
        return Colors.lime;
    }
  }

  void navigateToDetail(Todo todo) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TodoDetail(todo)),
    );

    if (result == true) {
      getData();
    }
  }
}
