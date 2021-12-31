import 'package:flutter/material.dart';
import 'package:todolistcw1/views/appbar.dart';
import 'package:todolistcw1/views/todolist.dart';

void main() {

  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todos',
      theme: ThemeData(fontFamily: 'Manrope', hintColor: Colors.black26),
      home: new MyHomePage(title: 'Todos'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: 
      Column(
        
        children: <Widget>[
          SimpleAppBar("WORK TODO"),
          Expanded(child: TodoList()),
        ],
      ), 
    );
  }
}
