import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helper/localizationHelper.dart';
import '../provider/lessonProvider.dart';
import '../widget/bottomSheet/addHomeworkBottomSheet.dart';
import '../widget/bottomSheet/addTestBottomSheet.dart';
import '../model/addBottomSheet.dart';
import '../model/subject.dart';
import '../model/lesson.dart';

class SubjectChooser extends StatefulWidget {
  static const ROUTE_NAME = 'subject_chooser';

  @override
  _SubjectChooserState createState() => _SubjectChooserState();
}

class _SubjectChooserState extends State<SubjectChooser> {
  AddBottomSheet _addBottomSheet;
  LocalizationHelper localizationHelper;

  void _showAddHomework(List<Lesson> lessonsForSubject) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _addBottomSheet == AddBottomSheet.homeworkBottomSheet
        ? AddHomeworkBottomSheet(lessonsForSubject)
        : AddTestBottomSheet(lessonsForSubject)
    ).then((value) {
      if (value == true)
        Navigator.of(context).pop();
    });
  }

  Widget _buildListTile(Subject subject, List<Lesson> lessonsForSubject) {
    List<String> daysList = lessonsForSubject.map((Lesson lesson) => localizationHelper.localize('day_${lesson.day}')).toList();
    String days = daysList.join(', ');

    return InkWell(
      onTap: () => _showAddHomework(lessonsForSubject),
      radius: 4.0,
      child: ListTile(
        title: Text(subject.subject),
        subtitle: Text(days),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _addBottomSheet = ModalRoute.of(context).settings.arguments;
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