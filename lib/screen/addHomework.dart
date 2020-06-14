import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/localizationHelper.dart';
import '../provider/lessonProvider.dart';
import '../widget/bottomSheet/addHomeworkBottomSheet.dart';
import '../model/subject.dart';
import '../model/lesson.dart';

class AddHomework extends StatefulWidget {
  static const ROUTE_NAME = 'add_homework';

  @override
  _AddHomeworkState createState() => _AddHomeworkState();
}

class _AddHomeworkState extends State<AddHomework> {
  LocalizationHelper localizationHelper;

  void _showAddHomework(Subject subject, List<Lesson> lessonsForSubject) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => AddHomeworkBottomSheet(subject, lessonsForSubject)
    ).then((value) {
      if (value == true)
        Navigator.of(context).pop();
    });
  }

  Widget _buildListTile(Subject subject, List<Lesson> lessonsForSubject) {
    List<String> daysList = lessonsForSubject.map((Lesson lesson) => localizationHelper.localize('day_${lesson.day}')).toList();
    String days = daysList.join(', ');

    return InkWell(
      onTap: () => _showAddHomework(subject, lessonsForSubject),
      radius: 4.0,
      child: ListTile(
        title: Text(subject.subject),
        subtitle: Text(days),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    localizationHelper = LocalizationHelper.of(context);
    LessonProvider lessonProvider = Provider.of<LessonProvider>(context, listen: false);

    List<Subject> subjects = lessonProvider.subjects;
    List<Lesson> lessons = lessonProvider.lessons;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizationHelper.localize('fab_add_homework')),
      ),
      body: Column(
        children: <Widget>[
          Card(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(16.0, 12.0, 0.0, 12.0),
              child: Text(
                localizationHelper.localize('text_select_subject'),
                style: Theme.of(context).textTheme.subtitle2.copyWith(
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: subjects.length,
              itemBuilder: (_, int index) {
                Subject subject = subjects.elementAt(index);
                List<Lesson> lessonsForSubject = lessons.where((Lesson lesson) => lesson.subjectId == subject.id).toList();

                return _buildListTile(subject, lessonsForSubject);
              },
            ),
          ),
        ],
      )
    );
  }
}