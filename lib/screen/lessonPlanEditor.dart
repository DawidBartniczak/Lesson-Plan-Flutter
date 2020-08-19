import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helper/localizationHelper.dart';
import '../provider/lessonProvider.dart';
import '../model/lesson.dart';
import '../widget/lessonEditorListTile.dart';
import '../widget/bottomSheet/addLessonBottomSheet.dart';

class LessonPlanEditor extends StatefulWidget {
  static const ROUTE_NAME = 'lessonPlanEditor';

  @override
  _LessonPlanEditorState createState() => _LessonPlanEditorState();
}

class _LessonPlanEditorState extends State<LessonPlanEditor> {
  LessonProvider _lessonProvider;
  List<Lesson> _lessons;

  void _showAddLesson(int day) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => AddLessonBottomSheet(day)
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

  List<Widget> _lessonsForDay(int day, List<Lesson> lessons) {
    return lessons
      .where((Lesson lesson) => lesson.day == day)
      .map((Lesson lesson) {
        return LessonEditorListTile(lesson);
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
    _lessonProvider = Provider.of<LessonProvider>(context);
    _lessons = _lessonProvider.lessons;

    return Scaffold(
      appBar: AppBar(
        title: Text(LocalizationHelper.of(context).localize('screen_lessonplaneditor')),
      ),
      body: _buildLessonsList(_lessons)
    );
  }
}
