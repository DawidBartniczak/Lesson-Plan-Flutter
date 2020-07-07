import 'package:flutter/material.dart';

import '../widget/dayChanger.dart';
import '../widget/lessonList.dart';

class LessonPlanScreen extends StatefulWidget {
  @override
  _LessonPlanScreenState createState() => _LessonPlanScreenState();
}

class _LessonPlanScreenState extends State<LessonPlanScreen> {
  int _day = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        DayChanger(
          () {
            if (_day != 1)
            setState(() => _day--);
          },
          () {
            if (_day != 5)
              setState(() => _day++);
          },
          _day
        ),
        Expanded(
          child: LessonList(_day)
        )
      ],
    );
  }
}