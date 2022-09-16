import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:posts_offline_first/config/const.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseConnect {
  late Database _database;

  Future<Database> get database async {
    _database = await _initDB();
    return _database;
  }

  Future<Database> _initDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String databasePath = dir.path + DATABASE_NAME;

    var db = await openDatabase(databasePath, version: 1, onCreate: _onCreate);

    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute(CREATE_COMMENT_TABLE);
  }

  Future close() async {
    var dbClient = await database;
    return dbClient.close();
  }

  Future<List<Map<String, dynamic>>> getAllPosts() async {
    final db = await database;
    List<Map<String, dynamic>> items = await db.query(
      'post',
      orderBy: 'id ASC',
    );
    print(items);
    return items;
  }
}
