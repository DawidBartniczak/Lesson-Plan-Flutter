import 'package:flutter/material.dart';

import '../helper/localizationHelper.dart';
import '../model/subject.dart';
import '../model/lesson.dart';

class SubjectListTile extends StatelessWidget {
  final Subject _subject;
  final List<Lesson> _lessonsForSubject;
  final Function _callback;

  @override
  Widget build(BuildContext context) {
    List<String> daysList = _lessonsForSubject.map((Lesson lesson) => LocalizationHelper.of(context).localize('day_${lesson.day}')).toList();
    String days = daysList.join(', ');

    return InkWell(
      onTap: () => _callback(_lessonsForSubject),
      radius: 4.0,
      child: ListTile(
        title: Text(_subject.subject),
        subtitle: Text(days),
      ),
    );
  }

  SubjectListTile(this._subject, this._lessonsForSubject, this._callback);
}