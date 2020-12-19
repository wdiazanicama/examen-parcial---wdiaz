import 'package:flutter_sqlite/assemblers/teacher_assembler.dart';
import 'package:flutter_sqlite/infrastructure/teacher_repository.dart';
import 'package:flutter_sqlite/infrastructure/database_migration.dart';
import 'package:flutter_sqlite/model/teacher.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteTeacherRepository implements TeacherRepository {
  final assembler = TeacherAssembler();

  @override
  DatabaseMigration databaseMigration;

  SqfliteTeacherRepository(this.databaseMigration);

  @override
  Future<int> insert(Teacher teacher) async {
    final db = await databaseMigration.db();
    var id = await db.insert(assembler.tableName, assembler.toMap(teacher));
    return id;
  }

  @override
  Future<int> delete(Teacher teacher) async {
    final db = await databaseMigration.db();
    int result = await db.delete(assembler.tableName,
        where: assembler.columnId + " = ?", whereArgs: [teacher.id]);
    return result;
  }

  @override
  Future<int> update(Teacher teacher) async {
    final db = await databaseMigration.db();
    int result = await db.update(assembler.tableName, assembler.toMap(teacher),
        where: assembler.columnId + " = ?", whereArgs: [teacher.id]);
    return result;
  }

  @override
  Future<List<Teacher>> getList() async {
    final db = await databaseMigration.db();
    var result = await db
        .rawQuery("SELECT * FROM teachers order by nombre ASC, grado ASC");
    List<Teacher> teachers = assembler.fromList(result);
    return teachers;
  }

  Future<int> getCount() async {
    final db = await databaseMigration.db();
    var result = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM teachers'));
    return result;
  }
}
