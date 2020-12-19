import 'package:flutter/material.dart';
import 'package:flutter_sqlite/infrastructure/sqflite_course_repository.dart';
import 'package:flutter_sqlite/infrastructure/database_migration.dart';
import 'package:flutter_sqlite/infrastructure/sqflite_teacher_repository.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ReportPage1 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ReportPageState();
}

class ReportPageState extends State<ReportPage1> {
  SqfliteCourseRepository courseRepository =
      SqfliteCourseRepository(DatabaseMigration.get);
  SqfliteTeacherRepository teacherRepository =
      SqfliteTeacherRepository(DatabaseMigration.get);

  int courses = 0;
  int teachers = 0;

  @override
  Widget build(BuildContext context) {
    this.getCourses();
    this.getTeachers();

    return Scaffold(
      appBar: AppBar(
        title: Text('Resumen'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            color: Colors.orange,
            child: Icon(FontAwesomeIcons.graduationCap),
            height: 100,
            width: 100,
          ),
          Text('Cursos : ' + courses.toString()),
          Divider(),
          Container(
            color: Colors.blue,
            child: Icon(FontAwesomeIcons.userTie),
            height: 100,
            width: 100,
          ),
          Text('profesores : ' + teachers.toString()),
          Divider(),
          Container(
            color: Colors.purple,
            child: Icon(FontAwesomeIcons.userGraduate),
            height: 100,
            width: 100,
          ),
          Text('Monto Total Cursos: '),
          Divider(),
        ],
      ),
    );
  }

  void getCourses() {
    print('Main Thread getData');
    final futureResult = courseRepository.getCount();
    print('Main Thread getList ' + futureResult.toString());
    futureResult.then((courseCount) {
      print('Main Thread getList .then');
      setState(() {
        courses = courseCount;
      });
      debugPrint("Main Thread - Items: " + courses.toString());
    });
  }

  void getTeachers() {
    print('Main Thread getData');
    final futureResult = teacherRepository.getCount();
    print('Main Thread getList ' + futureResult.toString());
    futureResult.then((teacherCount) {
      print('Main Thread getList .then');
      setState(() {
        teachers = teacherCount;
      });
      debugPrint("Main Thread - Items: " + teachers.toString());
    });
  }
}
