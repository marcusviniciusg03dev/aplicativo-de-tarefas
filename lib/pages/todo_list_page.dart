import 'package:flutter/material.dart';
import 'package:task_list/models/Todo.dart';
import 'package:task_list/repositories/TodoRepository.dart';
import 'package:task_list/widgets/TodoItem.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController todoController = TextEditingController();

  final todoRepository = TodoRepository();
  List<Todo> todos = [];

  Todo? deletedTodo;
  int? deletedTodoPos;

  String? errorText;

  @override
  void initState() {
    super.initState();

    todoRepository.getTodoList().then((value) {
      setState(() {
        todos = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
          backgroundColor: Color(0xff7733FF),
          body: Center(
            child: Container(
              width: screenSize.width * .9,
              constraints: BoxConstraints(maxHeight: screenSize.height * .7),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: TextField(
                        controller: todoController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Ex. Estudar Flutter',
                            labelText: 'Adicione uma tarefa',
                            errorText: errorText,
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: Color(0xff7733FF),
                              width: 2,
                            )),
                            labelStyle: TextStyle(color: Color(0xff7733FF))),
                      )),
                      SizedBox(
                        width: 8,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            final todoText = todoController.text;

                            if (todoText.trim().isEmpty) {
                              setState(() {
                                errorText = 'Dê um título para a sua tarefa!';
                              });
                              return;
                            }

                            setState(() {
                              todos.add(Todo(
                                  title: todoText, dateTime: DateTime.now()));
                            });
                            todoController.clear();
                            todoRepository.saveTodoList(todos);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff7733FF),
                              padding: EdgeInsets.all(14)),
                          child: Icon(
                            Icons.add,
                            size: 30,
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Flexible(
                    child: ListView(shrinkWrap: true, children: [
                      for (Todo todo in todos)
                        TodoListItem(todo: todo, onDelete: onDeleteTodo)
                    ]),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Text(
                              'Você possui ${todos.length} ${todos.length == 1 ? 'tarefa' : 'tarefas'}.')),
                      SizedBox(
                        width: 8,
                      ),
                      ElevatedButton(
                          onPressed: showTodosDeletionDialog,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff7733FF),
                              padding: EdgeInsets.all(14)),
                          child: Text('Limpar tudo'))
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }

  void onDeleteTodo(Todo todo) {
    deletedTodo = todo;
    deletedTodoPos = todos.indexOf(todo);

    setState(() {
      todos.remove(todo);
    });

    todoRepository.saveTodoList(todos);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Tarefa "${todo.title}" foi removida com sucesso.',
          style: TextStyle(color: Colors.blue[400]),
        ),
        backgroundColor: Colors.white,
        action: SnackBarAction(
            label: 'Desfazer',
            onPressed: () {
              setState(() {
                todos.insert(deletedTodoPos!, deletedTodo!);
              });
              todoRepository.saveTodoList(todos);
            }),
        duration: const Duration(seconds: 5)));
  }

  void showTodosDeletionDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Limpar tudo?'),
              content:
                  Text('Você tem certeza que deseja limpar todas as tarefas?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style:
                      TextButton.styleFrom(foregroundColor: Colors.blue[200]),
                  child: Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    deleteAllTodos();
                  },
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: Text('Limpar tudo'),
                ),
              ],
            ));
  }

  void deleteAllTodos() {
    setState(() {
      todos.clear();
    });
    todoRepository.saveTodoList(todos);
  }
}
