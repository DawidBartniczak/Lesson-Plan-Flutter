import 'package:flutter/material.dart';
import 'package:lessonplan/provider/lessonProvider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../helper/localizationHelper.dart';
import '../provider/homeworkProvider.dart';
import '../model/homework.dart';

class TestListTile extends StatelessWidget {

  Future<bool> _showDeleteConfirm(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(LocalizationHelper.of(context).localize('text_confirmation')),
          content: Text(LocalizationHelper.of(context).localize('homework_remove_message')),
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
    Homework homework = Provider.of<Homework>(context, listen: false);
    HomeworkProvider _homeworkProvider = Provider.of<HomeworkProvider>(context, listen: false);
    LessonProvider _lessonProvider = Provider.of<LessonProvider>(context, listen: false);

    return Dismissible(
      key: ValueKey(homework.id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(16),
        color: Theme.of(context).errorColor,
        child: Icon(Icons.delete),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => _showDeleteConfirm(context),
      onDismissed: (_) => _homeworkProvider.deleteHomework(homework.id),
      child: ListTile(
        title: Text(homework.name),
        subtitle: Text(_lessonProvider.lessonSubjectForId(homework.lessonID)),
        leading: CircleAvatar(
          radius: 24,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(DateFormat('dd.MM').format(homework.date)),
            ),
          ),
        ),
        trailing: Consumer<Homework>(
          builder: (BuildContext context, Homework homework, _) {
            return IconButton(
              icon: const Icon(Icons.check),
              color: !homework.isDone ? Colors.grey : Colors.green,
              onPressed: homework.changeIsDone,
            );
          },
        ),
      ),
    );
  }
}