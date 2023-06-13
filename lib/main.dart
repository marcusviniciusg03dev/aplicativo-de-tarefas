import 'package:flutter/material.dart';
import 'package:task_list/pages/todo_list_page.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: TodoListPage());
  }
}
