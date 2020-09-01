import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/lessonProvider.dart';
import '../model/lesson.dart';

class LessonList extends StatelessWidget {
  final int _day;

  @override
  Widget build(BuildContext context) {
    LessonProvider _lessonProvider = Provider.of<LessonProvider>(context);
    List<Lesson> _lessons = _lessonProvider.lessons;
    List<Lesson> _lessonsForDay =_lessons.where((Lesson lesson) => lesson.day == _day).toList();

    return ListView(
      children: _lessonsForDay.map((Lesson lesson) {
        String _startHour = lesson.startHour < 10 ? "0${lesson.startHour}" : lesson.startHour.toString();
        String _startMinute = lesson.startMinute < 10 ? "0${lesson.startMinute}" : lesson.startMinute.toString();
        String _endHour = lesson.endHour < 10 ? "0${lesson.endHour}" : lesson.endHour.toString();
        String _endMinute = lesson.endMinute < 10 ? "0${lesson.endMinute}" : lesson.endMinute.toString();

        return ListTile(
          title: Text(lesson.subject),
          subtitle: Text('$_startHour:$_startMinute - $_endHour:$_endMinute'),
          leading: CircleAvatar(
            radius: 24,
            child: Text(lesson.classroom),
          ),
        );
      }).toList()
    );
  }

  LessonList(this._day);
}