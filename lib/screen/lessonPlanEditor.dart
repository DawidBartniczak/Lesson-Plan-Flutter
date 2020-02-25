import 'package:flutter/material.dart';
import 'package:lessonplan/model/localizationHelper.dart';

import '../model/databaseHelper.dart';
import '../model/admobHelper.dart';
import '../model/lesson.dart';
import '../widget/bottomSheet/addLessonBottomSheet.dart';

class LessonPlanEditor extends StatefulWidget {
  static const ROUTE_NAME = 'lessonPlanEditor';

  @override
  _LessonPlanEditorState createState() => _LessonPlanEditorState();
}

class _LessonPlanEditorState extends State<LessonPlanEditor> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  Future<List<Lesson>> _lessons;

  @override
  void initState() {
    AdMobHelper.hideBanner();
    AdMobHelper.loadInterstitial();
    loadData();
    super.initState();
  }

  @override
  void dispose() {
    AdMobHelper.showBanner();
    super.dispose();
  }

  void loadData() {
    setState(() {
      _lessons = _databaseHelper.lessons;
    });
  }

  void _insertLessonIntoDatabase(Lesson lesson) {
    _databaseHelper.insertLesson(lesson)
      .then((_) {
        loadData();
        AdMobHelper.showInterstitial();
      });
  }

  void _showAddLesson(int day) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
          title: Text(LocalizationHelper.of(context).localize('lesson_remove_title')),
          content: Text(LocalizationHelper.of(context).localize('lesson_remove_message')),
          actions: <Widget>[
            FlatButton(
              child: Text(LocalizationHelper.of(context).localize('text_no')),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            FlatButton(
              child: Text(LocalizationHelper.of(context).localize('text_yes')),
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
        title: Text(LocalizationHelper.of(context).localize('text_lesson_add')),
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
        icon: const Icon(Icons.delete),
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
          title: Text(LocalizationHelper.of(context).localize('day_1')),
          children: <Widget>[
            ..._lessonsForDay(1, lessons),
            _addLessonButton(1),
          ],
        ),
        ExpansionTile(
          title: Text(LocalizationHelper.of(context).localize('day_2')),
          children: <Widget>[
            ..._lessonsForDay(2, lessons),
            _addLessonButton(2),
          ],
        ),
        ExpansionTile(
          title: Text(LocalizationHelper.of(context).localize('day_3')),
          children: <Widget>[
            ..._lessonsForDay(3, lessons),
            _addLessonButton(3),
          ],
        ),
        ExpansionTile(
          title: Text(LocalizationHelper.of(context).localize('day_4')),
          children: <Widget>[
            ..._lessonsForDay(4, lessons),
            _addLessonButton(4),
          ],
        ),
        ExpansionTile(
          title: Text(LocalizationHelper.of(context).localize('day_5')),
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
        title: Text(LocalizationHelper.of(context).localize('screen_lessonplaneditor')),
      ),
      body: FutureBuilder(
        future: _lessons,
        builder: (_, AsyncSnapshot<List<Lesson>> snapshot) {
          if (snapshot.hasData) {
            return _buildLessonsList(snapshot.data);
          } else {
            return const Center(
              child: const CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
