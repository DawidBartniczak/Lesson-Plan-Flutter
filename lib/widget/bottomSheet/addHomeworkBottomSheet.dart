import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/homework.dart';

class AddHomeworkBottomSheet extends StatefulWidget {
  final Function(Homework) _addToDatabase;
  final int _day;
  final int _lessonID;

  @override
  _AddHomeworkBottomSheetState createState() => _AddHomeworkBottomSheetState();

  AddHomeworkBottomSheet(this._addToDatabase, this._day, this._lessonID);
}

class _AddHomeworkBottomSheetState extends State<AddHomeworkBottomSheet> {
  final GlobalKey<FormState> _homeworkFormKey = GlobalKey<FormState>();
  String _homeworkContent;

  @override
  Widget build(BuildContext context) {
    bool _isTablet = MediaQuery.of(context).size.width > 600;

    return Padding(
      padding: EdgeInsets.all(!_isTablet ? 16 : 24),
      child: Form(
        key: _homeworkFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              keyboardAppearance: Brightness.light,
              decoration: InputDecoration(
                labelText: 'Treść zadania domowego',
                filled: true
              ),
              validator: (String value) {
                if (value.isEmpty)
                  return 'Treść jest wymagana';
                return null;
              },
              onSaved: (String value) => _homeworkContent = value,
            ),
            SizedBox(height: !_isTablet ? 8 : 16,),
            RaisedButton(
              color: Theme.of(context).accentColor,
              textColor: Colors.white,
              child: Text('Zapisz'),
              onPressed: () {
                if (_homeworkFormKey.currentState.validate()) {
                  _homeworkFormKey.currentState.save();
                  DateTime nextLessonDate = DateTime.now()
                    .subtract(Duration(days: DateTime.now().weekday - widget._day))
                    .add(Duration(days: 7));
                  widget._addToDatabase(Homework(
                    id: null,
                    lessonID: widget._lessonID,
                    name: _homeworkContent,
                    date: nextLessonDate
                  ));
                  Navigator.of(context).pop();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}