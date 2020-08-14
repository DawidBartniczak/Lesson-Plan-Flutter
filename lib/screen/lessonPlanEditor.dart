import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lessonplan/helper/localizationHelper.dart';

import '../provider/lessonProvider.dart';
import '../provider/homeworkProvider.dart';
import '../provider/testProvider.dart';
import '../model/lesson.dart';
import '../model/bottomMenuAction.dart';
import '../widget/bottomSheet/addLessonBottomSheet.dart';
import '../widget/bottomMenuButton.dart';

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

  Future<bool> _showDeleteConfirm(_) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(LocalizationHelper.of(context).localize('text_confirmation')),
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
    return Dismissible(
      key: ValueKey(lesson.id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(16),
        color: Theme.of(context).errorColor,
        child: Icon(Icons.delete),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: _showDeleteConfirm,
      onDismissed: (_) {
        _lessonProvider.deleteLesson(lesson.id);
        Provider.of<HomeworkProvider>(context, listen: false).deleteHomeworkForLesson(lesson.id);
        Provider.of<TestProvider>(context, listen: false).deleteTestsForLesson(lesson.id);
      },
      child: ListTile(
        title: Text(lesson.subject),
        subtitle: Text('${lesson.startHour}:${lesson.startMinute} - ${lesson.endHour}:${lesson.endMinute}'),
        leading: CircleAvatar(
          radius: 24,
          child: Text(lesson.classroom),
        ),
        trailing: BottomMenuButton(
          context: context,
          actions: [
            BottomMenuAction(
              name: 'Delete',
              icon: Icon(Icons.delete),
              value: 1
            ),
            BottomMenuAction(
              name: 'Edit',
              icon: Icon(Icons.edit),
              value: 2
            ),
            BottomMenuAction(
              name: 'Details',
              icon: Icon(Icons.info),
              value: 3
            ),
          ],
          onSelected: (value) {
            print('Selected: $value');
          },
        ),
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
