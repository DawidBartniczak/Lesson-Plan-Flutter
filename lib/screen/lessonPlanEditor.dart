import 'package:flutter/material.dart';
import 'package:rounded_modal/rounded_modal.dart';

import '../widget/addLessonBottomSheet.dart';

class LessonPlanEditor extends StatefulWidget {
  @override
  _LessonPlanEditorState createState() => _LessonPlanEditorState();
}

class _LessonPlanEditorState extends State<LessonPlanEditor> {
  void showAddLesson() {
    showRoundedModalBottomSheet(
      context: context,
      dismissOnTap: false,
      builder: (_) {
        return AddLessonBottomSheet();
      }
    );
  }

  Widget addLessonButton() {
    return InkWell(
      onTap: () => showAddLesson(),
      child: ListTile(
        leading: Icon(Icons.add),
        title: Text('Dodaj'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edytor Planu',),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Poniedziałek', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          addLessonButton(),
          Divider(),
          ListTile(
            title: Text('Wtorek', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          addLessonButton(),
          Divider(),
          ListTile(
            title: Text('Środa', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          addLessonButton(),
          Divider(),
          ListTile(
            title: Text('Czwartek', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          addLessonButton(),
          Divider(),
          ListTile(
            title: Text('Piątek', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          addLessonButton(),
          Divider(),
        ],
      ),
    );
  }
}
