import 'package:flutter_sqlite/infrastructure/database_migration.dart';
import 'package:flutter_sqlite/model/teacher.dart';

abstract class TeacherRepository {
  DatabaseMigration databaseMigration;
  Future<int> insert(Teacher student);
  Future<int> update(Teacher student);
  Future<int> delete(Teacher student);
  Future<List<Teacher>> getList();
}
