import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_list/models/Todo.dart';

class TodoRepository {
  final todoListKey = 'todo_list';

  late SharedPreferences sharedPreferences;

  Future<List<Todo>> getTodoList() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final jsonTodos =
        json.decode(sharedPreferences.getString(todoListKey) ?? '[]') as List;
    return jsonTodos.map((e) => Todo.fromJson(e)).toList();
  }

  void saveTodoList(List<Todo> todos) {
    final jsonString = json.encode(todos);
    sharedPreferences.setString(todoListKey, jsonString);
  }
}
