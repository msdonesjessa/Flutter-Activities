import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Todo {
  final int userId;
  final int id;
  final String title;
  final bool completed;

  const Todo({
    required this.userId,
    required this.id,
    required this.title,
    required this.completed,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      completed: json['completed'],
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Consume API',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController myController = new TextEditingController();
  String name = '';
  late Future<List<Todo>> todo;

  @override
  void initState() {
    super.initState();
    todo = fetchTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Consume API'),
        ),
        body: Center(
          child: FutureBuilder<List<Todo>>(
            future: todo,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot.data![index].title),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              return CircularProgressIndicator();
            },
          ),
        ));
  }
}

Future<List<Todo>> fetchTodos() async {
  final response =
      await get(Uri.parse('https://jsonplaceholder.typicode.com/todos'));

  if (response.statusCode == 200) {
    return (jsonDecode(response.body) as List)
        .map((e) => Todo.fromJson(e))
        .toList();
  } else {
    throw Exception('Failed to load todo');
  }
}
