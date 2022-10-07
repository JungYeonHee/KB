import 'package:todolist/data/todo.dart';
import 'package:todolist/main.dart';
import 'package:sqflite/sqflite.dart';

import 'dart:convert';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = "kb.db";
  static const _databaseVersion = 1;
  static const table = "todo";

  static const columnId = "id";
  static const columnTitle = "title";
  static const columnDate = "date";
  static const columnCategory = "category";
  static const columnColor = "color";
  static const columnMemo = "memo";
  static const columnDone = "done";

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
//    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE IF NOT EXISTS $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnTitle String,
            $columnCategory String,
            $columnColor INTEGER DEFAULT 0,
            $columnDate INTEGER DEFAULT 0,
            $columnDone INTEGER DEFAULT 0,
            $columnMemo String
          )
          ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
  }

  Future<int> insertTodo(Todo todo) async {
    Database db = (await database)!; // null이 아닌 값을 가져오겠다

    Map<String, dynamic> data = todo.toJson();
    data.remove("id");
    return db.insert(table, data);
  }

  Future<int> updateTodo(Todo todo) async {
    Database db = (await database)!;

    return db.update(table, todo.toJson(), where: "$columnId = ?",
    whereArgs: [todo.id]);
  }

  Future<List<Todo>> queryAllTodo() async {
    Database db = (await database)!;

    List<Map<String, dynamic>> data = await db.query(table);

    List<Todo> todos = [];

    for(final d in data){

      todos.add(
        Todo.fromDatabase(d)
      );
    }

    return todos;
  }

  Future<List<Todo>> queryTodoByDate( DateTime date) async {
    Database db = (await database)!;

    DateTime st = DateTime(date.year, date.month, date.day, 0, 0);
    DateTime et = DateTime(date.year, date.month, date.day, 23, 59);

    List<Map<String, dynamic>> data = await db.query(table,
      where: "$columnDate >= ? and $columnDate <= ?",
      whereArgs: [st.millisecondsSinceEpoch, et.millisecondsSinceEpoch]
    );

    List<Todo> todos = [];

    for(final d in data){
      todos.add(
          Todo.fromDatabase(d)
      );
    }

    return todos;
  }

}