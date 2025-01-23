// ignore_for_file: depend_on_referenced_packages

import 'package:chat_app_signalr/Database/dss_db.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  Database? _database;

  static final DatabaseService _instance = DatabaseService._internal();

  DatabaseService._internal();

  factory DatabaseService() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initialize();
    return _database!;
  }

  Future<String> get fullPath async {
    const name = "DSS.db";
    final path = await getDatabasesPath();
    return join(path, name);
  }

  Future<void> deleteDatabase() async {
    const name = "DSS.db";
    final path = await getDatabasesPath();
    final fullPath2 = join(path, name);
    databaseFactory.deleteDatabase(fullPath2);
    _database = null;
  }

  Future<Database> _initialize() async {
    final path = await fullPath;
    var database = await openDatabase(path,
        version: 1,
        onCreate: create,
        onUpgrade: onUpgrade,
        singleInstance: true);
    return database;
  }

  void onUpgrade(Database db, int oldVersion, int newVersion) {
    if (oldVersion < newVersion) {}
  }

  Future<void> create(Database database, int version) async =>
      await DSSDB().createTable(database);
}
