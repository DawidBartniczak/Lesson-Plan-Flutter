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
        return ListTile(
          title: Text(lesson.subject),
          subtitle: Text('${lesson.startHour}:${lesson.startMinute} - ${lesson.endHour}:${lesson.endMinute}'),
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