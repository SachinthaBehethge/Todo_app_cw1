import 'package:flutter/material.dart';
import 'package:todolistcw1/model/todo.dart';
import 'package:todolistcw1/util/dbhelper.dart';
import 'package:intl/intl.dart';

DbHelper helper = DbHelper();

class TodoDetail extends StatefulWidget {
  final Todo todo;
  TodoDetail(this.todo);

  @override
  State<StatefulWidget> createState() => TodoDetailState(todo);
}

class TodoDetailState extends State<TodoDetail> {
  Todo todo;
  final _priorities = ["High (RED)", "Medium (ORANGE)", "Low (YELLOW)"];
  String _priority = "Low";
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit;
  final _formKey = GlobalKey<FormState>();

  void initState() {
    super.initState();
    isEdit = todo.title == '' ? false : true;
    titleController.text = todo.title;
    descriptionController.text = todo.description;
  }

  TodoDetailState(this.todo);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(
      fontSize: 16.0,
      color: Colors.black54,
      fontWeight: FontWeight.w600,
    );

    return Scaffold(

      backgroundColor: Color(0XFF0E1731),
      body: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 90.0, 20.0, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(

                isEdit ? "EDIT\nTASK" : "ADD\nTASK",

                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    height: 1.2,

                    fontSize: 50.0,
                    color: Colors.white),
              ),

              Container(
                margin: EdgeInsets.symmetric(vertical: 30.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black38,
                        blurRadius: 15.0,
                        spreadRadius: -5.0,
                        offset: Offset(0.0, 7.0)),
                  ],
                ),
                width: 320.0,
                height: 400.0,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25.0, vertical: 0.0),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: <Widget>[
                        TextFormField(
                            maxLength: 30,
                            onSaved: (value) {
                              todo.title = value;
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Title cannot be null';
                              }

                              if (value.length > 30) {
                                return 'Max length for title is 30.';
                              }
                            },
                            keyboardType: TextInputType.text,
                            controller: titleController,
                            style: textStyle,
                            decoration: InputDecoration(
                              hintText: 'Title',
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 15.0),
                              labelStyle: textStyle,
                            )),
                        TextFormField(
                            maxLength: 50,
                            onSaved: (value) {
                              todo.description = value;
                            },
                            keyboardType: TextInputType.text,
                            controller: descriptionController,
                            style: textStyle,
                            decoration: InputDecoration(
                              hintText: 'Description',
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 15.0),
                              labelStyle: textStyle,
                            )),
                        InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Priority',
                            contentPadding: EdgeInsets.zero,
                          ),

                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(

                              items: _priorities.map((String value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              style: textStyle,
                              value: retrievePriority(todo.priority),
                              onChanged: (value) => updatePriority(value),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 50.0,
                        ),
                        Row(
                          children: [
                            RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 30.0),
                              elevation: 2.0,
                              textColor: Colors.white,
                              color: Color(0XFFFF8700),
                              onPressed: () => save(),
                              child: Text(
                                isEdit ? "Edit" : "Add",
                                style: TextStyle(
                                    fontSize: 15.0, fontWeight: FontWeight.w600),
                              ),
                            ),

                            Visibility(
                              visible: isEdit? true :false,
                              child: Container(
                                margin: EdgeInsets.only(left: 10.0),
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0)),
                                  padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 30.0),
                                  elevation: 2.0,
                                  textColor: Colors.white,
                                  color: Color(0XFFFF0000),
                                  onPressed: () {
                                    debugPrint("Click Floated Back.");
                                    confirmDelete();
                                  },
                                  child: Text(
                                    "Delete",
                                    style: TextStyle(
                                        fontSize: 15.0, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                          ],

                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void confirmDelete() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            title: Text("Are you sure you want to delete this?",
                style: TextStyle(fontSize: 15.0)),
            actions: <Widget>[
              new FlatButton(
                  child: new Text('CANCEL'),
                  onPressed: () => Navigator.of(context).pop()),
              new FlatButton(
                  child: new Text(
                    'DELETE',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    helper.deleteTodo(todo.id);
                    Navigator.of(context).pop();
                    Navigator.pop(context, true);
                  })
            ],
          ),
    );
  }

  void save() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      todo.date = new DateFormat.yMd().format(DateTime.now());
      if (todo.id != null) {
        helper.updateTodo(todo);
      } else {
        helper.insertTodo(todo);
      }
      Navigator.pop(context, true);
    }
  }

  void updatePriority(String value) {
    switch (value) {
      case 'High (RED)':
        todo.priority = 1;
        break;
      case 'Medium (ORANGE)':
        todo.priority = 2;
        break;
      case 'Low (YELLOW)':
        todo.priority = 3;
        break;
    }

    setState(() {
      _priority = value;
    });
  }

  String retrievePriority(int value) {
    return _priorities[value - 1];
  }

  void updateTitle() {
    setState(() {
      todo.title = titleController.text;
    });
  }

  void updateDescription() {
    setState(() {
      todo.description = descriptionController.text;
    });
  }
}
