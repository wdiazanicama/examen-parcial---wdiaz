import 'package:flutter/material.dart';
import 'package:flutter_sqlite/infrastructure/sqflite_course_repository.dart';
import 'package:flutter_sqlite/infrastructure/database_migration.dart';
import 'package:flutter_sqlite/model/course.dart';

SqfliteCourseRepository courseRepository =
    SqfliteCourseRepository(DatabaseMigration.get);
final List<String> choices = const <String>[
  'Save Course & Back',
  'Delete Course',
  'Back to List'
];

const mnuSave = 'Save Course & Back';
const mnuDelete = 'Delete Course';
const mnuBack = 'Back to List';

class CourseDetailPage extends StatefulWidget {
  final Course course;
  CourseDetailPage(this.course);

  @override
  State<StatefulWidget> createState() => CourseDetailPageState(course);
}

class CourseDetailPageState extends State<CourseDetailPage> {
  Course course;
  CourseDetailPageState(this.course);
  final teckstackList = [1, 2, 3, 4];

  int teckstack = 1;

  TextEditingController nombreController = TextEditingController();
  TextEditingController costoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    nombreController.text = this.course.nombre;
    costoController.text = this.course.costo.toString();
    TextStyle textStyle = Theme.of(context).textTheme.headline6;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(course.nombre),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: select,
              itemBuilder: (BuildContext context) {
                return choices.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: Padding(
            padding: EdgeInsets.only(top: 35.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    TextField(
                      controller: nombreController,
                      style: textStyle,
                      onChanged: (value) => this.updateNombre(),
                      decoration: InputDecoration(
                          labelText: "Nombre",
                          labelStyle: textStyle,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          )),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                        child: TextField(
                          controller: costoController,
                          style: textStyle,
                          onChanged: (value) => this.updateCosto(),
                          decoration: InputDecoration(
                              labelText: "Costo",
                              labelStyle: textStyle,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              )),
                        )),
                    ListTile(
                        title: DropdownButton<String>(
                      items: teckstackList.map((int value) {
                        return DropdownMenuItem<String>(
                          value: value.toString(),
                          child: Text(value.toString() + "- especialidad"),
                        );
                      }).toList(),
                      style: textStyle,
                      value: retrieveSemester(course.teckstack).toString(),
                      onChanged: (value) => updateTeckStack(value),
                    ))
                  ],
                )
              ],
            )));
  }

  void select(String value) async {
    int result;
    switch (value) {
      case mnuSave:
        save();
        break;
      case mnuDelete:
        Navigator.pop(context, true);
        if (course.id == null) {
          return;
        }
        result = await courseRepository.delete(course);
        if (result != 0) {
          AlertDialog alertDialog = AlertDialog(
            title: Text("Delete Course"),
            content: Text("The Course has been deleted"),
          );
          showDialog(context: context, builder: (_) => alertDialog);
        }
        break;
      case mnuBack:
        Navigator.pop(context, true);
        break;
      default:
    }
  }

  void save() {
    if (course.id != null) {
      debugPrint('update');
      courseRepository.update(course);
    } else {
      debugPrint('insert');
      courseRepository.insert(course);
    }
    Navigator.pop(context, true);
  }

  void updateTeckStack(String value) {
    switch (value) {
      case "1":
        course.teckstack = 1;
        break;
      case "2":
        course.teckstack = 2;
        break;
      case "3":
        course.teckstack = 3;
        break;
      case "4":
        course.teckstack = 4;
        break;
    }
    setState(() {
      teckstack = int.parse(value);
    });
  }

  int retrieveSemester(int value) {
    return teckstackList[value - 1];
  }

  void updateNombre() {
    course.nombre = nombreController.text;
  }

  void updateCosto() {
    course.costo = int.parse(costoController.text);
  }
}
