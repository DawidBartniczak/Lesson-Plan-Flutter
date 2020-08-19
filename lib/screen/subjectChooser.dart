import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helper/localizationHelper.dart';
import '../provider/lessonProvider.dart';
import '../widget/chooseSubjectLabel.dart';
import '../widget/subjectListTile.dart';
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

  void _showAddBottomSheet(List<Lesson> lessonsForSubject) {
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

  @override
  Widget build(BuildContext context) {
    _addBottomSheet = ModalRoute.of(context).settings.arguments;
    localizationHelper = LocalizationHelper.of(context);
    LessonProvider lessonProvider = Provider.of<LessonProvider>(context, listen: false);

    List<Subject> subjects = lessonProvider.subjects;
    List<Lesson> lessons = lessonProvider.lessons;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _addBottomSheet == AddBottomSheet.homeworkBottomSheet
            ? localizationHelper.localize('fab_add_homework')
            : localizationHelper.localize('fab_add_test')
        ),
      ),
      body: Column(
        children: <Widget>[
          ChooseSubjectLabel(),
          Expanded(
            child: ListView.builder(
              itemCount: subjects.length,
              itemBuilder: (_, int index) {
                Subject subject = subjects.elementAt(index);
                List<Lesson> lessonsForSubject = lessons.where((Lesson lesson) => lesson.subjectId == subject.id).toList();

                return SubjectListTile(subject, lessonsForSubject, _showAddBottomSheet);
              },
            ),
          ),
        ],
      )
    );
  }
}