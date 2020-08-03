import 'dart:async';
import 'package:date_format/date_format.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tasker/models/task.dart';

class DB {
  static Database _db;
  static final String _dbName = "tasks_v5";
  static const _priorities = [0, 1, 2];
  Future<Database> get db async {
    if (_db == null) {
      _db = await openDatabase(
        join(await getDatabasesPath(), "$_dbName.db"),
        version: 1,
        onCreate: (db, version) => db.execute(
          "CREATE TABLE IF NOT EXISTS $_dbName (id INTEGER PRIMARY KEY, title TEXT, description TEXT, priority INTEGER, createdOn TEXT, remainder Text, isDone INTEGER)",
        ),
      );
    }
    return _db;
  }

  // saving task
  Future<Task> save(Task task) async {
    Database dbClient = await db;
    task.id = await dbClient.insert(_dbName, task.toMap());
    return task;
  }

  // getting tasks list
  Future<List<Task>> getTasks(DateTime _date, List<int> priorities) async {
    Database dbClient = await db;
    String date = formatDate(_date, ['d', ' ', 'M', ' ', 'yyyy']);
    priorities = priorities.length > 0 ? priorities : _priorities;

    List<Map<String, dynamic>> tasks = await dbClient.query(
      _dbName,
      where: "createdOn = ? AND priority IN (${priorities.join(', ')})",
      whereArgs: [date],
      orderBy: "isDone, priority",
    );

    return tasks.map((e) => Task.fromMap(e)).toList();
  }

  // updating task
  Future<int> update(int id, Task task) async {
    Database dbClient = await db;
    return await dbClient
        .update(_dbName, task.toMap(), where: "id = ?", whereArgs: [id]);
  }

  // delete task
  Future<int> delete(int id) async {
    Database dbClient = await db;
    return await dbClient.delete(_dbName, where: "id = ?", whereArgs: [id]);
  }
}
