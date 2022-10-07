// 홈화면

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todolist/data/database.dart';
import 'package:todolist/main.dart';
import 'package:todolist/view/todo.dart';

import '../data/todo.dart';

class TodoHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TodoHomePageState();
  }
}

class _TodoHomePageState extends State<TodoHomePage> {
  DatabaseHelper databaseHelper = DatabaseHelper.instance;

  List<Todo> todos = [];

  Future<void> getTodayTodo() async{
    // 오늘 날짜로 기록된 두 리스트를 데이터베이스에서 불러옴
    List<Todo> todayTodo = await databaseHelper.queryTodoByDate(DateTime.now());

    setState(() {
      todos = todayTodo;
    });
  }

  @override
  void initState() {
    getTodayTodo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Todo todo = Todo(
              id: -1,
              title: "",
              category: "",
              memo: "",
              date: DateTime.now().subtract(Duration(days: -1)),
              done: false,
              color: Colors.amberAccent);

          Todo? _todo = await Navigator.of(context).push(
              MaterialPageRoute(builder: (ctx) => TodoCreatePage(todo: todo)));

          if (_todo != null) {
            getTodayTodo();

            // setState(() {
            //   todos.add(_todo);
            // });
          }
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      // This trailing comma makes
      body: Container(
        child: ListView.builder(
          itemBuilder: (ctx, idx) {
            if (idx == 0) {
              return Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Text(
                  "오늘 하루",
                  style: TextStyle(
                      fontSize: 24,
                      color: txtColor),
                ),
              );
            } else if (idx == 1) {
              List<Todo> undone = todos.where((t) => !t.done).toList();

              return Container(
                child: Column(
                  children: List.generate(undone.length, (_idx) {
                    return InkWell(
                        child: TodoCard(
                          todo: undone[_idx],
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                                title: Text("${undone[_idx].title} 완료하셨나요?"),
                                content: Text("메뉴를 선택해주세요"),
                                actions: [
                                  TextButton(
                                    child: Text("닫기"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text("수정하기"),
                                    onPressed: () async {
                                      await Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (ctx) => TodoCreatePage(
                                              todo: undone[_idx]),
                                        )
                                      );
                                      getTodayTodo();
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text("완료하기"),
                                    onPressed: () {
                                      setState(() {
                                        undone[_idx].done = true;
                                        databaseHelper.updateTodo(undone[_idx]);

                                      });

                                      Navigator.of(context).pop();
                                    },
                                  )
                                ]),
                          );
                        });
                  }),
                ),
              );
            } else if (idx == 2) {
              return Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Text(
                  "완료된 하루",
                  style: TextStyle(fontSize: 24, color: txtColor),
                ),
              );
            } else if (idx == 3) {
              List<Todo> done = todos.where((t) => t.done).toList();
              return Container(
                child: Column(
                  children: List.generate(done.length, (_idx) {
                    return TodoCard(todo: done[_idx]);
                  }),
                ),
              );
            }
            return Container();
          },
          itemCount: 5,
        ),
      ),
    );
  }
}
