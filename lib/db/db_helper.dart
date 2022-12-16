import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app_v2/services/notification_services.dart';

import '../models/task.dart';

class DBHelper {
  Database? _db;
  final int _version = 1;
  final String _tableName = 'tasks';

  Future<Database?> get db async {
    if (_db == null) {
      _db = await initDb();
      return _db;
    } else {
      return _db;
    }
  }

  Future<Database?> initDb() async {
    try {
      String _path = '${await getDatabasesPath()}tasks.db';
      _db = await openDatabase(_path,
          version: _version, onCreate: _onCreate, onUpgrade: _onUpgrade);

      print('Database created =========');
    } catch (e) {
      print('initDb Method Error! = $e');
    }
    return _db;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $_tableName(id INTEGER PRIMARY KEY,title TEXT,note TEXT,date TEXT,startTime TEXT,endTime TEXT,remind INTEGER,repeat TEXT,color INTEGER,isCompleted INTEGER);');
  }

  _onUpgrade(Database db, int oldversion, int newversion) {
    print('onUpgrade ====================================\n');
  }

  Future<int> insert(Task? task) async {
    Database? mydb = await db;
    print('Insert ====');

    return await mydb!.insert(_tableName, task!.toMap());
  }

  Future<int> delete(int id) async {
    Database? mydb = await db;
    print('Delete ====');

    return await mydb!.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteAll() async {
    Database? mydb = await db;
    print('Delete All ====');
    return await mydb!.delete(_tableName);
  }

  Future<int> update(int id) async {
    Database? mydb = await db;
    print('Update ====');
    return await mydb!.rawUpdate(
        'UPDATE $_tableName SET isCompleted = ? WHERE id = ?', [1, id]);
  }

  Future<List<Map<String, Object?>>> query() async {
    Database? mydb = await db;
    print('Query ====');
    return await mydb!.query(_tableName);
  }
}
