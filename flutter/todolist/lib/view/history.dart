import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todolist/data/database.dart';
import 'package:todolist/view/todo.dart';

import '../data/todo.dart';
import '../main.dart';

class TodoHistoryPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _TodoHistoryPageState();
  }
}

class _TodoHistoryPageState extends State<TodoHistoryPage> {

  DatabaseHelper dbHelper = DatabaseHelper.instance;
  List<Todo> todos = [];
  List<DateTime> dates = [];

  Future<void> getAllTodos() async {
    List<Todo> allTodo = await dbHelper.queryAllTodo();
    setState(() {
      todos = allTodo;

      for(Todo t in todos){
        DateTime date = DateTime(t.date.year, t.date.month, t.date.day);
        if(!dates.contains(date)){
          dates.add(date);
        }
      }
    });
  }

  @override
  void initState() {
    getAllTodos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Container(
        child: ListView.builder(
            itemBuilder: (ctx, idx){
              DateTime st = dates[idx];
              List<Todo> dateTodo = todos.where((t) =>
                t.date.year == st.year && t.date.month == st.month
                  && t.date.day == st.day).toList();

              List<Widget> widgets = [
                Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 16, vertical: 16
                    ),
                    child: Text("${st.month}월 ${st.day}일", style: largeStyle))
              ];

              widgets.addAll(List.generate(dateTodo.length, (_idx) {
                return TodoCard(todo: dateTodo[_idx]);
              }));

              return Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                    children: widgets,
                  ),
                );
            },
          itemCount: dates.length,

        )
      ),
    );
  }

}