import 'package:flutter/material.dart';

import '../../model/localizationHelper.dart';
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
    LocalizationHelper localizationHelper = LocalizationHelper.of(context);
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
                labelText: localizationHelper.localize('text_homework_content'),
                filled: true
              ),
              validator: (String value) {
                if (value.isEmpty)
                  return localizationHelper.localize('error_contentempty');
                return null;
              },
              onSaved: (String value) => _homeworkContent = value,
            ),
            SizedBox(height: !_isTablet ? 8 : 16,),
            RaisedButton(
              color: Theme.of(context).accentColor,
              textColor: Colors.white,
              child: Text(localizationHelper.localize('text_save')),
              onPressed: () {
                if (_homeworkFormKey.currentState.validate()) {
                  _homeworkFormKey.currentState.save();
                  DateTime nextLessonDate = DateTime.now()
                    .subtract(Duration(days: DateTime.now().weekday - widget._day));
                  if (nextLessonDate.isBefore(DateTime.now())) {
                    nextLessonDate = nextLessonDate.add(Duration(days: 7));
                  }
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