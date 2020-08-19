import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../helper/localizationHelper.dart';
import '../provider/homeworkProvider.dart';
import '../provider/lessonProvider.dart';
import '../model/homework.dart';
import '../model/bottomMenuAction.dart';
import '../widget/bottomMenuButton.dart';

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

  void _removeHomework(BuildContext context, Homework homework) async {
    bool confirmation = await _showDeleteConfirm(context);

    if (confirmation) {
      HomeworkProvider homeworkProvider = Provider.of<HomeworkProvider>(context, listen: false);

      homeworkProvider.deleteHomework(homework.id);
    }
  }

  void _showEditHomework(BuildContext context, Homework homework) {
    TextEditingController _contentController = TextEditingController(text: homework.name);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(LocalizationHelper.of(context).localize('homework_edit')),
          content: TextField(
            autofocus: true,
            controller: _contentController,
            decoration: InputDecoration(
              labelText: LocalizationHelper.of(context).localize('text_homework_content'),
              filled: true,
            ),
          ),
          contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 8),
          actions: <Widget>[
            FlatButton(
              child: Text(LocalizationHelper.of(context).localize('text_cancel')),
              onPressed: () => Navigator.of(context).pop(),
            ),
            FlatButton(
              child: Text(LocalizationHelper.of(context).localize('text_save')),
              onPressed: () {
                if (_contentController.text != "" && _contentController.text != homework.name) {
                  homework.changeName(_contentController.text);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    Homework homework = Provider.of<Homework>(context);
    LessonProvider _lessonProvider = Provider.of<LessonProvider>(context, listen: false);

    return ListTile(
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
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.check),
            color: !homework.isDone ? Colors.grey : Colors.green,
            onPressed: homework.changeIsDone,
          ),
          BottomMenuButton(
            context: context,
            actions: [
              BottomMenuAction(
                name: LocalizationHelper.of(context).localize('text_delete'),
                icon: Icon(Icons.delete),
                value: 1
              ),
              BottomMenuAction(
                name: LocalizationHelper.of(context).localize('text_edit'),
                icon: Icon(Icons.edit),
                value: 2
              ),
            ],
            closeLabel: LocalizationHelper.of(context).localize('text_close'),
            onSelected: (value) {
              switch (value) {
                case 1:
                  _removeHomework(context, homework);
                  break;
                case 2:
                  _showEditHomework(context, homework);
                  break;
              }
            },
          )
        ],
      ),
    );
  }
}