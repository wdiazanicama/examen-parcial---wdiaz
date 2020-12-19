import 'package:flutter_sqlite/assemblers/assembler.dart';
import 'package:flutter_sqlite/model/course.dart';

class CourseAssembler implements Assembler<Course> {
  final tableName = 'courses';
  final columnId = 'id';
  final columnNombre = 'nombre';
  final columnTeckStack = 'teckstack';
  final columnCosto = 'costo';

  @override
  Course fromMap(Map<String, dynamic> query) {
    Course course =
        Course(query[columnId], query[columnNombre], query[columnTeckStack]);
    return course;
  }

  @override
  Map<String, dynamic> toMap(Course course) {
    return <String, dynamic>{
      columnNombre: course.nombre,
      columnTeckStack: course.teckstack,
      columnCosto: course.costo
    };
  }

  Course fromDbRow(dynamic row) {
    return Course.withId(row[columnId], row[columnNombre], row[columnTeckStack],
        row[columnCosto]);
  }

  @override
  List<Course> fromList(result) {
    List<Course> courses = List<Course>();
    var count = result.length;
    for (int i = 0; i < count; i++) {
      courses.add(fromDbRow(result[i]));
    }
    return courses;
  }
}
