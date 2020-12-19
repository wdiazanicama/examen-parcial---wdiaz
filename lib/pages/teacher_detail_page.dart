import 'package:flutter/material.dart';
import 'package:flutter_sqlite/infrastructure/sqflite_teacher_repository.dart';
import 'package:flutter_sqlite/infrastructure/database_migration.dart';
import 'package:flutter_sqlite/model/teacher.dart';

SqfliteTeacherRepository teacherRepository =
    SqfliteTeacherRepository(DatabaseMigration.get);
final List<String> choices = const <String>[
  'Save Teacher & Back',
  'Delete Teacher',
  'Back to List'
];

const mnuSave = 'Save Teacher & Back';
const mnuDelete = 'Delete Teacher';
const mnuBack = 'Back to List';

class TeacherDetailPage extends StatefulWidget {
  final Teacher teacher;
  TeacherDetailPage(this.teacher);

  @override
  State<StatefulWidget> createState() => TeacherDetailPageState(teacher);
}

class TeacherDetailPageState extends State<TeacherDetailPage> {
  Teacher teacher;
  TeacherDetailPageState(this.teacher);

  TextEditingController nombreController = TextEditingController();
  TextEditingController gradoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    nombreController.text = this.teacher.nombre;
    gradoController.text = teacher.grado;
    TextStyle textStyle = Theme.of(context).textTheme.headline6;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(teacher.nombre),
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
                          controller: gradoController,
                          style: textStyle,
                          onChanged: (value) => this.updateGrado(),
                          decoration: InputDecoration(
                              labelText: "Grado",
                              labelStyle: textStyle,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              )),
                        )),
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
        if (teacher.id == null) {
          return;
        }
        result = await teacherRepository.delete(teacher);
        if (result != 0) {
          AlertDialog alertDialog = AlertDialog(
            title: Text("Delete Teacher"),
            content: Text("The Teacher has been deleted"),
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
    if (teacher.id != null) {
      debugPrint('update');
      teacherRepository.update(teacher);
    } else {
      debugPrint('insert');
      teacherRepository.insert(teacher);
    }
    Navigator.pop(context, true);
  }

  void updateNombre() {
    teacher.nombre = nombreController.text;
  }

  void updateGrado() {
    teacher.grado = gradoController.text;
  }
}
