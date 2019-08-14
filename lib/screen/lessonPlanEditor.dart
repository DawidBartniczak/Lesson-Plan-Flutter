import 'package:flutter/material.dart';
import 'package:rounded_modal/rounded_modal.dart';

import '../model/databaseHelper.dart';
import '../model/lesson.dart';
import '../widget/addLessonBottomSheet.dart';

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

  void insertLessonIntoDatabase(Lesson lesson) {
    _databaseHelper.insertLesson(lesson)
      .then((_) => loadData());
  }

  void showAddLesson(int day) {
    showRoundedModalBottomSheet(
      context: context,
      dismissOnTap: false,
      builder: (_) {
        return AddLessonBottomSheet(
          insertLessonIntoDatabase,
          day
        );
      }
    );
  }

  Future<bool> showDeleteConfirm() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
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

  Widget addLessonButton(int day) {
    return InkWell(
      onTap: () => showAddLesson(day),
      child: ListTile(
        leading: Icon(Icons.add),
        title: Text('Dodaj'),
      ),
    );
  }

  Widget lessonTile(Lesson lesson) {
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
          showDeleteConfirm()
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

  List<Widget> lessonsForDay(int day, List<Lesson> lessons) {
    return lessons
      .where((Lesson lesson) => lesson.day == day)
      .map((Lesson lesson) {
        return lessonTile(lesson);
      })
      .toList();
  }

  Widget buildLessonsList(List<Lesson> lessons) {
    return ListView(
      children: <Widget>[
        ExpansionTile(
          onExpansionChanged: (_) => loadData(),
          title: Text('Poniedziałek', style: TextStyle(fontWeight: FontWeight.bold)),
          children: <Widget>[
            ...lessonsForDay(1, lessons),
            addLessonButton(1),
          ],
        ),
        ExpansionTile(
          onExpansionChanged: (_) => loadData(),
          title: Text('Wtorek', style: TextStyle(fontWeight: FontWeight.bold)),
          children: <Widget>[
            ...lessonsForDay(2, lessons),
            addLessonButton(2),
          ],
        ),
        ExpansionTile(
          onExpansionChanged: (_) => loadData(),
          title: Text('Środa', style: TextStyle(fontWeight: FontWeight.bold)),
          children: <Widget>[
            ...lessonsForDay(3, lessons),
            addLessonButton(3),
          ],
        ),
        ExpansionTile(
          onExpansionChanged: (_) => loadData(),
          title: Text('Czwartek', style: TextStyle(fontWeight: FontWeight.bold)),
          children: <Widget>[
            ...lessonsForDay(4, lessons),
            addLessonButton(4),
          ],
        ),
        ExpansionTile(
          onExpansionChanged: (_) => loadData(),
          title: Text('Piątek', style: TextStyle(fontWeight: FontWeight.bold)),
          children: <Widget>[
            ...lessonsForDay(5, lessons),
            addLessonButton(5),
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
            return buildLessonsList(snapshot.data);
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
