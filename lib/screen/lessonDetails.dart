import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rounded_modal/rounded_modal.dart';

import '../model/databaseHelper.dart';
import '../model/lesson.dart';
import '../model/homework.dart';
import '../model/test.dart';
import '../widget/bottomSheet/addHomeworkBottomSheet.dart';
import '../widget/bottomSheet/addTestBottomSheet.dart';

class LessonDetails extends StatefulWidget {
  static const ROUTE_NAME = 'lessonDetails';

  @override
  _LessonDetailsState createState() => _LessonDetailsState();
}

class _LessonDetailsState extends State<LessonDetails> {
  DatabaseHelper _databaseHelper = DatabaseHelper();

  void showAddHomework(int lessonID, int lessonDay) {
    showRoundedModalBottomSheet(
      context: context,
      dismissOnTap: false,
      builder: (_) {
        return AddHomeworkBottomSheet(
          _insertHomeworkIntoDatabase,
          lessonDay,
          lessonID
        );
      }
    );
  }

  void showAddTest() {
    showRoundedModalBottomSheet(
      context: context,
      dismissOnTap: false,
      builder: (_) {
        return AddTestBottomSheet();
      }
    );
  }

  void _insertHomeworkIntoDatabase(Homework homework) {
    _databaseHelper.insertHomework(homework)
      .then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final Lesson lesson = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Informacje'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            child: ListTile(
              title: Text(lesson.subject),
              subtitle: Text('${lesson.startHour}:${lesson.startMinute} - ${lesson.endHour}:${lesson.endMinute}'),
              leading: CircleAvatar(
                radius: 24,
                child: Text(lesson.classroom),
              ),
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
            child: FutureBuilder(
              future: _databaseHelper.getHomeworkForLesson(lesson.id),
              builder: (_, AsyncSnapshot<Homework> snapshot) {
                if (snapshot.hasData) {
                  final Homework homework = snapshot.data;

                  return ListTile(
                    title: Text(homework.name),
                    subtitle: Text(homework.date.toString()),
                    leading: Icon(Icons.home),
                    trailing: IconButton(
                      icon: Icon(Icons.check),
                      tooltip: !homework.isDone ? 'Nie Zrobione' : 'Zrobione',
                      color: !homework.isDone ? Colors.grey : Colors.green,
                      onPressed: () {
                        _databaseHelper.changeHomeworkState(!homework.isDone, homework.id)
                          .then((_) => setState(() {}));
                      },
                    ),
                  );
                } else {
                  return InkWell(
                    borderRadius: BorderRadius.circular(4.0),
                    onTap: () => showAddHomework(lesson.id, lesson.day),
                    child: ListTile(
                      title: Text('Dodaj zadanie domowe'),
                      leading: Icon(Icons.home),
                      trailing: Icon(Icons.add),
                    ),
                  );
                }
              },
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
            child: FutureBuilder(
              future: _databaseHelper.getTestForLesson(lesson.id),
              builder: (_, AsyncSnapshot<Test> snapshot) {
                if (snapshot.hasData) {
                  final Test test = snapshot.data;

                  return ListTile(
                    title: Text(test.name),
                    subtitle: Text(test.date),
                    leading: Icon(Icons.library_books)
                  );
                } else {
                  return InkWell(
                    borderRadius: BorderRadius.circular(4.0),
                    onTap: showAddTest,
                    child: ListTile(
                      title: Text('Dodaj sprawdzian'),
                      leading: Icon(Icons.library_books),
                      trailing: Icon(Icons.add),
                    ),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}