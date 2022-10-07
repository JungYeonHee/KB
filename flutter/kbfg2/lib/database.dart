// Database code

import 'package:kbfg2/main.dart';
import 'package:sqflite/sqflite.dart';

import 'dart:convert';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = "kb.db";
  static const _databaseVersion = 1;
  static const table = "stock";

  static const columnId = "id";
  static const columnPrice = "price";
  static const columnName = "name";
  static const columnAmount = "amount";
  static const columnMarketCap = "cap";

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
            $columnPrice INTEGER DEFAULT 0,
            $columnAmount String,
            $columnMarketCap String,
            $columnName String
          )
          ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
  }

  // insert, query, update, delete

  Future<int> insertStock(Stock stock) async {
    Database? db = await database;

    if(db == null) return -1;

    Map<String, dynamic> data = stock.toJson();

    data.remove("id"); // id 키를 삭제

    return db.insert(table, data);
  }

  Future<int> updateStock(Stock stock) async {
    Database? db = await database;

    if(db == null) return -1;

    Map<String, dynamic> data = stock.toJson();

    return db.update(table, data, where: "$columnId = ?" , whereArgs: [data["id"]]);
  }

  Future<List<Stock>> queryAllStock() async {
    Database? db = await database;
    if(db == null) return [];

    List<Stock> stocks = [];
    List<dynamic> data = await db.query(table);

    for(final d in data){
      Stock stock = Stock.fromDatabase(d as Map<String, dynamic>);
      stocks.add(stock);
    }

    return stocks;
  }

  Future<int> deleteStock(Stock stock) async {
    Database? db = await database;
    if(db == null) return -1;

    return db.delete(table, where: "$columnId = ?", whereArgs: [stock.id]);

  }
}