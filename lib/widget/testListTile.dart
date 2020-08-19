import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../helper/localizationHelper.dart';
import '../provider/testProvider.dart';
import '../provider/lessonProvider.dart';
import '../model/test.dart';
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

  void _removeTest(BuildContext context, Test test) async {
    bool confirmation = await _showDeleteConfirm(context);

    if (confirmation) {
      TestProvider homeworkProvider = Provider.of<TestProvider>(context, listen: false);

      homeworkProvider.deleteTest(test.id);
    }
  }

  void _showEditTest(BuildContext context, Test test) {
    TextEditingController _contentController = TextEditingController(text: test.name);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(LocalizationHelper.of(context).localize('test_edit')),
          content: TextField(
            autofocus: true,
            controller: _contentController,
            decoration: InputDecoration(
              labelText: LocalizationHelper.of(context).localize('text_test_subject'),
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
                if (_contentController.text != "" && _contentController.text != test.name) {
                  test.changeName(_contentController.text);
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
    Test test = Provider.of<Test>(context);
    LessonProvider _lessonProvider = Provider.of<LessonProvider>(context, listen: false);

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
      trailing: BottomMenuButton(
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
        tooltip: LocalizationHelper.of(context).localize('text_more'),
        closeLabel: LocalizationHelper.of(context).localize('text_close'),
        onSelected: (value) {
          switch (value) {
            case 1:
              _removeTest(context, test);
              break;
            case 2:
              _showEditTest(context, test);
              break;
          }
        },
      )
    );
  }
}