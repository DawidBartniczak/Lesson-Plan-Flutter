import 'package:flutter/material.dart';
import 'package:rounded_modal/rounded_modal.dart';

import '../model/databaseHelper.dart';
import '../model/lesson.dart';
import '../widget/bottomSheet/addLessonBottomSheet.dart';

class LessonPlanEditor extends StatefulWidget {
  @override
  _LessonPlanEditorState createState() => _LessonPlanEditorState();
}

class _LessonPlanEditorState extends State<LessonPlanEditor> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  Future<List<Lesson>> _lessons;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  void loadData() {
    setState(() {
      _lessons = _databaseHelper.lessons;
    });
  }

  void _insertLessonIntoDatabase(Lesson lesson) {
    _databaseHelper.insertLesson(lesson)
      .then((_) => loadData());
  }

  void _showAddLesson(int day) {
    showRoundedModalBottomSheet(
      context: context,
      dismissOnTap: false,
      builder: (_) {
        return AddLessonBottomSheet(
          _insertLessonIntoDatabase,
          day
        );
      }
    );
  }

  Future<bool> _showDeleteConfirm() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          title: Text('Czy na pewno?'),
          content: Text('Czy na pewno chcesz usunąć tą lekcję?'),
          actions: <Widget>[
            FlatButton(
              child: Text('Nie'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            FlatButton(
              child: Text('Tak'),
              textColor: Colors.red,
              onPressed: () => Navigator.of(context).pop(true),
            )
          ],
        );
      }
    );
  }

  Widget _addLessonButton(int day) {
    return InkWell(
      onTap: () => _showAddLesson(day),
      child: ListTile(
        leading: Icon(Icons.add),
        title: Text('Dodaj'),
      ),
    );
  }

  Widget _lessonTile(Lesson lesson) {
    return ListTile(
      title: Text(lesson.subject),
      subtitle: Text('${lesson.startHour}:${lesson.startMinute} - ${lesson.endHour}:${lesson.endMinute}'),
      leading: CircleAvatar(
        radius: 24,
        child: Text(lesson.classroom),
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        color: Colors.red,
        onPressed: () {
          _showDeleteConfirm()
            .then((bool isConfirmed) {
              if (isConfirmed) {
                _databaseHelper.deleteLesson(lesson.id)
                  .then((_) => loadData());
              }
            });
        },
      ),
    );
  }

  List<Widget> _lessonsForDay(int day, List<Lesson> lessons) {
    return lessons
      .where((Lesson lesson) => lesson.day == day)
      .map((Lesson lesson) {
        return _lessonTile(lesson);
      })
      .toList();
  }

  Widget _buildLessonsList(List<Lesson> lessons) {
    return ListView(
      children: <Widget>[
        ExpansionTile(
          title: Text('Poniedziałek', style: TextStyle(fontWeight: FontWeight.bold)),
          children: <Widget>[
            ..._lessonsForDay(1, lessons),
            _addLessonButton(1),
          ],
        ),
        ExpansionTile(
          title: Text('Wtorek', style: TextStyle(fontWeight: FontWeight.bold)),
          children: <Widget>[
            ..._lessonsForDay(2, lessons),
            _addLessonButton(2),
          ],
        ),
        ExpansionTile(
          title: Text('Środa', style: TextStyle(fontWeight: FontWeight.bold)),
          children: <Widget>[
            ..._lessonsForDay(3, lessons),
            _addLessonButton(3),
          ],
        ),
        ExpansionTile(
          title: Text('Czwartek', style: TextStyle(fontWeight: FontWeight.bold)),
          children: <Widget>[
            ..._lessonsForDay(4, lessons),
            _addLessonButton(4),
          ],
        ),
        ExpansionTile(
          title: Text('Piątek', style: TextStyle(fontWeight: FontWeight.bold)),
          children: <Widget>[
            ..._lessonsForDay(5, lessons),
            _addLessonButton(5),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edytor Planu',),
      ),
      body: FutureBuilder(
        future: _lessons,
        builder: (_, AsyncSnapshot<List<Lesson>> snapshot) {
          if (snapshot.hasData) {
            return _buildLessonsList(snapshot.data);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
