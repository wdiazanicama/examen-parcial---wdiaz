import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseMigration {
  static final _instance = DatabaseMigration._internal();
  static DatabaseMigration get = _instance;
  static Database _db;
  final List<String> initScripts = [
    '''
    CREATE TABLE courses(
      id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      nombre TEXT NOT NULL,
      teckstack INTEGER NULL,
      costo INTEGER NOT NULL
    );
    ''',
    '''
    CREATE TABLE teachers(
      id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      nombre TEXT NOT NULL,
      grado TEXT NULL
       );
    '''
  ];

  List<String> migrationScripts = [];
  /*List<String> migrationScripts = [
    '''
    ALTER TABLE courses ADD column rating REAL NOT NULL DEFAULT 0.00;
    ''',
    '''
    ALTER TABLE courses ADD column reviews INTEGER NOT NULL DEFAULT 0;
    ''',
  ];*/

  DatabaseMigration._internal();

  Future<Database> db() async {
    if (_db == null) {
      _db = await _init();
    }
    return _db;
  }

  Future<Database> _init() async {
    //var databasesPath = await getDatabasesPath();
    //String path = join(databasesPath, 'academic.db');
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'academio1.db');
    print(path);

    int version =
        migrationScripts.length <= 0 ? 1 : migrationScripts.length + 1;
    print("Version: " + version.toString());
    var db = await openDatabase(path,
        version: version, onCreate: _createDb, onUpgrade: _upgradeDb);
    return db;
  }

  void _createDb(Database db, int newVersion) async {
    initScripts.forEach((script) async => await db.execute(script));
  }

  void _upgradeDb(Database db, int oldVersion, int newVersion) async {
    print('oldVersion: ' + oldVersion.toString());
    print('newVersion: ' + newVersion.toString());
    for (var i = oldVersion - 1; i < newVersion - 1; i++) {
      print('migrationScripts[i] => ' + i.toString());
      await db.execute(migrationScripts[i]);
    }
  }
}
