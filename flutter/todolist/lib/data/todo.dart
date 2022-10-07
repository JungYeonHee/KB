// Todo : 제목, 날짜, 완료여부, 색상, 메모, id

import 'package:flutter/material.dart';

class Todo {
  int id;
  String title;
  String category;
  DateTime date;
  bool done;
  Color color;
  String memo;

  //생성자
  Todo({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.done,
    required this.color,
    required this.memo
  });

  Map<String, dynamic> toJson() {

    return {
      "id": this.id,
      "title": this.title,
      "category": this.category,
      "date": this.date.millisecondsSinceEpoch,
      "done": this.done ? 1 : 0,
      "color": this.color.value,
      "memo": this.memo
    };
  }

  factory Todo.fromDatabase(Map<String, dynamic> data){
    return Todo(
      id: data["id"],
      title: data["title"].toString(),
      category: data["category"].toString(),
      memo: data["memo"].toString(),
      date: DateTime.fromMicrosecondsSinceEpoch(data["date"] as int),
      color: Color(data["color"]),
      done: data["done"] == 0 ? false : true
    );
  }

}



