import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helper/localizationHelper.dart';
import '../model/lesson.dart';
import '../provider/lessonProvider.dart';
import '../provider/homeworkProvider.dart';
import '../provider/testProvider.dart';
import '../model/bottomMenuAction.dart';
import '../widget/bottomMenuButton.dart';

class LessonEditorListTile extends StatelessWidget {
  final Lesson _lesson;

  Future<bool> _showDeleteConfirm(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(LocalizationHelper.of(context).localize('text_confirmation')),
          content: Text(LocalizationHelper.of(context).localize('lesson_remove_message')),
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

  void _removeLesson(BuildContext context) async {
    bool confirmation = await _showDeleteConfirm(context);

    if (confirmation) {
      Provider.of<LessonProvider>(context, listen: false).deleteLesson(_lesson.id);
      Provider.of<HomeworkProvider>(context, listen: false).deleteHomeworkForLesson(_lesson.id);
      Provider.of<TestProvider>(context, listen: false).deleteTestsForLesson(_lesson.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(_lesson.subject),
      subtitle: Text('${_lesson.startHour}:${_lesson.startMinute} - ${_lesson.endHour}:${_lesson.endMinute}'),
      leading: CircleAvatar(
        radius: 24,
        child: Text(_lesson.classroom),
      ),
      trailing: BottomMenuButton(
        context: context,
        actions: [
          BottomMenuAction(
            name: LocalizationHelper.of(context).localize('text_delete'),
            icon: Icon(Icons.delete),
            value: 1
          ),
        ],
        closeLabel: LocalizationHelper.of(context).localize('text_close'),
        onSelected: (value) {
          switch (value) {
            case 1:
              _removeLesson(context);
              break;
          }
        },
      )
    );
  }

  LessonEditorListTile(this._lesson);
}