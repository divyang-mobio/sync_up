library sync_up;

import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  String dataBaseName, createDataBase;
  int version;

  DatabaseHelper(
      {required this.dataBaseName,
      required this.version,
      required this.createDataBase});

  // static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async => _database ??= await _init();

  Future<Database> _init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, dataBaseName);
    return await openDatabase(path, version: version, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(createDataBase);
  }

  Future<int> addData(
      {required String tableName, required Map<String, Object?> values}) async {
    Database db = await database;
    return await db.insert(tableName, values);
  }

  Future<List<Map<String, Object?>>> getData(
      {required String tableName}) async {
    Database db = await database;
    return await db.query(tableName);
  }

  deleteData({required String tableName, required int id}) async {
    Database db = await database;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  deleteAllData({required String tableName}) async {
    Database db = await database;
    return await db.delete(tableName);
  }

  updateData(
      {required String tableName,
      required Map<String, Object?> values,
      required int id}) async {
    Database db = await database;
    return await db.update(tableName, values, where: 'id = ?', whereArgs: [id]);
  }
}
