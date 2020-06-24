import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../model/localizationHelper.dart';
import '../provider/homeworkProvider.dart';
import '../provider/lessonProvider.dart';
import '../model/homework.dart';

class HomeworkScreen extends StatefulWidget {
  @override
  _HomeworkScreenState createState() => _HomeworkScreenState();
}

class _HomeworkScreenState extends State<HomeworkScreen> {
  HomeworkProvider _homeworkProvider;

  Future<bool> _showDeleteConfirm(_) {
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

  Widget _buildTistTile(Homework homework, LessonProvider lessonProvider) {
    return Dismissible(
      key: ValueKey(homework.id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(16),
        color: Theme.of(context).errorColor,
        child: Icon(Icons.delete),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: _showDeleteConfirm,
      onDismissed: (_) => _homeworkProvider.deleteHomework(homework.id),
      child: ListTile(
        title: Text(homework.name),
        subtitle: Text(lessonProvider.lessonSubjectForId(homework.lessonID)),
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
        trailing: IconButton(
          icon: const Icon(Icons.check),
          color: !homework.isDone ? Colors.grey : Colors.green,
          onPressed: () {
            
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _homeworkProvider = Provider.of<HomeworkProvider>(context);
    LessonProvider lessonProvider = Provider.of<LessonProvider>(context, listen: false);
    List<Homework> homework = _homeworkProvider.homework;


    return ListView(
      children: 
        homework.map((Homework homework) => _buildTistTile(homework, lessonProvider)).toList(),
    );
  }
}