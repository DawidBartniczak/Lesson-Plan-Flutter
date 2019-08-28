import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rounded_modal/rounded_modal.dart';

import '../model/localizationHelper.dart';
import '../model/databaseHelper.dart';
import '../model/admobHelper.dart';
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

  @override
  void initState() {
    AdMobHelper.hideBanner();
    AdMobHelper.loadInterstitial();
    super.initState();
  }

  void _showAddHomework(int lessonID, int lessonDay) {
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

  void _showAddTest(int lessonID, int lessonDay) {
    showRoundedModalBottomSheet(
      context: context,
      dismissOnTap: false,
      builder: (_) {
        return AddTestBottomSheet(
          _insertTestIntoDatabase,
          lessonDay,
          lessonID,
        );
      }
    );
  }

  void _insertHomeworkIntoDatabase(Homework homework) {
    _databaseHelper.insertHomework(homework)
      .then((_) {
        setState(() {});
        AdMobHelper.showInterstitial();
      });
  }

  void _insertTestIntoDatabase(Test test) {
    _databaseHelper.insertTest(test)
      .then((_) {
        setState(() {});
        AdMobHelper.showInterstitial();
      });
  }

  Widget _buildLessonTile(Lesson lesson) {
    return Card(
      child: ListTile(
        title: Text(lesson.subject),
        subtitle: Text('${lesson.startHour}:${lesson.startMinute} - ${lesson.endHour}:${lesson.endMinute}'),
        leading: CircleAvatar(
          radius: 24,
          child: Text(lesson.classroom),
        ),
      ),
    );
  }

  Widget _buildHomeworkTile(int lessonID, int lessonDay) {
    return Card(
      child: FutureBuilder(
        future: _databaseHelper.getHomeworkForLesson(lessonID),
        builder: (_, AsyncSnapshot<Homework> snapshot) {
          if (snapshot.hasData) {
            final Homework homework = snapshot.data;

            return ListTile(
              title: Text(homework.name),
              subtitle: Text(DateFormat('dd-MM-yyyy').format(homework.date)),
              leading: const Icon(Icons.home),
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
              onTap: () => _showAddHomework(lessonID, lessonDay),
              child: ListTile(
                title: Text(LocalizationHelper.of(context).localize('text_homework_add')),
                leading: const Icon(Icons.home),
                trailing: const Icon(Icons.add),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildTestTile(int lessonID, int lessonDay) {
    return Card(
      child: FutureBuilder(
        future: _databaseHelper.getTestForLesson(lessonID),
        builder: (_, AsyncSnapshot<Test> snapshot) {
          if (snapshot.hasData) {
            final Test test = snapshot.data;

            return ListTile(
              title: Text(test.name),
              subtitle: Text(DateFormat('dd-MM-yyyy').format(test.date)),
              leading: Icon(Icons.library_books)
            );
          } else {
            return InkWell(
              borderRadius: BorderRadius.circular(4.0),
              onTap: () => _showAddTest(lessonID, lessonDay),
              child: ListTile(
                title: Text(LocalizationHelper.of(context).localize('text_test_add')),
                leading: const Icon(Icons.library_books),
                trailing: const Icon(Icons.add),
              ),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Lesson lesson = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(LocalizationHelper.of(context).localize('screen_lessondetials')),
      ),
      body: Column(
        children: <Widget>[
          _buildLessonTile(lesson),
          _buildHomeworkTile(lesson.id, lesson.day),
          _buildTestTile(lesson.id, lesson.day),
        ],
      ),
    );
  }
}