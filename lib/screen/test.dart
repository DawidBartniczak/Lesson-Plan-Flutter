import 'package:flutter/material.dart';
import 'package:lessonplan/provider/lessonProvider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../provider/testProvider.dart';
import '../model/test.dart';

class TestScreen extends StatelessWidget {
  TestProvider _testProvider;
  LessonProvider _lessonProvider;

  Widget _buildTestTile(Test test) {
    return ListTile(
      title: Text(test.name),
      subtitle: Text(_lessonProvider.lessonSubjectForId(test.lessonID)),
      leading: CircleAvatar(
        radius: 24,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(DateFormat('dd.MM').format(test.date)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _testProvider = Provider.of<TestProvider>(context);
    _lessonProvider = Provider.of<LessonProvider>(context);
    List<Test> tests = _testProvider.tests;

    return ListView(
      children: tests.map((Test test) => _buildTestTile(test)).toList(),
    );
  }
}