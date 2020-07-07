import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../helper/localizationHelper.dart';
import '../provider/testProvider.dart';
import '../provider/lessonProvider.dart';
import '../model/test.dart';

class TestListTile extends StatelessWidget {
  final Test _test;

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

  @override
  Widget build(BuildContext context) {
    TestProvider _testProvider = Provider.of<TestProvider>(context, listen: false);
    LessonProvider _lessonProvider = Provider.of<LessonProvider>(context, listen: false);

    return Dismissible(
      key: ValueKey(_test.id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(16),
        color: Theme.of(context).errorColor,
        child: Icon(Icons.delete),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => _showDeleteConfirm(context),
      onDismissed: (_) => _testProvider.deleteTest(_test.id),
      child: ListTile(
        title: Text(_test.name),
        subtitle: Text(_lessonProvider.lessonSubjectForId(_test.lessonID)),
        leading: CircleAvatar(
          radius: 24,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(DateFormat('dd.MM').format(_test.date)),
            ),
          ),
        ),
      ),
    );
  }

  TestListTile(this._test);
}