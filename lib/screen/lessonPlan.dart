import 'package:flutter/material.dart';

import '../model/databaseHelper.dart';
import '../model/lesson.dart';

class LessonPlanScreen extends StatefulWidget {
  @override
  _LessonPlanScreenState createState() => _LessonPlanScreenState();
}

class _LessonPlanScreenState extends State<LessonPlanScreen> {
  DatabaseHelper _databaseHelper;
  Future<List<Lesson>> _lessons;

  @override
  void initState() {
    _databaseHelper = DatabaseHelper();
    loadData();
    super.initState();
  }

  void loadData() {
    setState(() {
      _lessons = _databaseHelper.lessons;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _lessons,
      builder: (_, AsyncSnapshot<List<Lesson>> snapshot) {
        if (snapshot.hasData) {
          List<Lesson> lessons = snapshot.data;

          if (lessons.length > 0) {
            return Container(color: Colors.blue,);
          } else {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Text(
                  'Dodaj lekcje do planu używając opcji kredki w dolnym menu.',
                  style: Theme.of(context).textTheme.subtitle,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}