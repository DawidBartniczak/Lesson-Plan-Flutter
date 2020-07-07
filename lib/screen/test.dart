import 'package:flutter/material.dart';
import 'package:lessonplan/provider/lessonProvider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../helper/localizationHelper.dart';
import '../provider/testProvider.dart';
import '../model/test.dart';

class TestScreen extends StatelessWidget {
  TestProvider _testProvider;
  LessonProvider _lessonProvider;

  Future<bool> _showDeleteConfirm(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(LocalizationHelper.of(context).localize('text_confirmation')),
          content: Text(LocalizationHelper.of(context).localize('test_remove_message')),
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

  Widget _buildTestTile(Test test, BuildContext context) {
    return Dismissible(
      key: ValueKey(test.id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(16),
        color: Theme.of(context).errorColor,
        child: Icon(Icons.delete),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => _showDeleteConfirm(context),
      child: ListTile(
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _testProvider = Provider.of<TestProvider>(context);
    _lessonProvider = Provider.of<LessonProvider>(context);
    List<Test> tests = _testProvider.tests;

    return tests.length > 0
      ? ListView(
        children: tests.map((Test test) => _buildTestTile(test, context)).toList(),
      )
      : Center(
        child: Text('Brak sprawdzianów.'),
      );
  }
}