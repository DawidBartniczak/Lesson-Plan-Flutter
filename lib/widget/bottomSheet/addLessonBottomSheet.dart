import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../provider/lessonProvider.dart';
import '../../model/localizationHelper.dart';
import '../../model/lesson.dart';

class AddLessonBottomSheet extends StatefulWidget {
  final int _day;

  @override
  _AddLessonBottomSheetState createState() => _AddLessonBottomSheetState();

  AddLessonBottomSheet(this._day);
}

class _AddLessonBottomSheetState extends State<AddLessonBottomSheet> {
  final GlobalKey<FormState> _lessonFormKey = GlobalKey<FormState>();
  final FocusNode _classroomFocusNode = FocusNode();
  String _subject;
  String _classroom;
  TimeOfDay _startTime;
  TimeOfDay _endTime;
  bool _timePicked = false;

  void pickStartDate() {
    showTimePicker(
      context: context,
      initialTime: _startTime == null ? TimeOfDay.now() : _startTime
    ).then((TimeOfDay startTime) {
      if (startTime != null) {
        DateTime now = DateTime.now();
        DateTime endDate = DateTime(now.year, now.month, now.day, startTime.hour, startTime.minute)
          .add(Duration(minutes: 45));
        _startTime = startTime;
        _endTime = TimeOfDay.fromDateTime(endDate);
        
        setState(() {
          _timePicked = true;
        });
      }
    });
  }

  String formValidaror(String value) {
    if (value.isEmpty)
      return LocalizationHelper.of(context).localize('error_fieldempty');
    return null;
  }

  @override
  Widget build(BuildContext context) {
    LocalizationHelper localizationHelper = LocalizationHelper.of(context);
    bool _isTablet = MediaQuery.of(context).size.width > 600;

    return SafeArea(
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Padding(
          padding: EdgeInsets.all(!_isTablet ? 16 : 24),
          child: Form(
            key: _lessonFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  keyboardAppearance: Brightness.light,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: localizationHelper.localize('text_lesson_subject'),
                    filled: true
                  ),
                  onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_classroomFocusNode),
                  validator: formValidaror,
                  onSaved: (String value) => _subject = value,
                ),
                SizedBox(height: !_isTablet ? 16 : 24,),
                TextFormField(
                  focusNode: _classroomFocusNode,
                  keyboardAppearance: Brightness.light,
                  decoration: InputDecoration(
                    labelText: localizationHelper.localize('text_lesson_classroom'),
                    filled: true
                  ),
                  validator: formValidaror,
                  onSaved: (String value) => _classroom = value,
                ),
                SizedBox(height: !_isTablet ? 16 : 24,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(!_timePicked 
                      ? localizationHelper.localize('text_select_hour')
                      : '${_startTime.hour}:${_startTime.minute} - ${_endTime.hour}:${_endTime.minute}'),
                    FlatButton(
                      child: Text(localizationHelper.localize('text_select')),
                      onPressed: pickStartDate,
                    ),
                  ],
                ),
                SizedBox(height: !_isTablet ? 8 : 16,),
                RaisedButton(
                  color: Theme.of(context).accentColor,
                  textColor: Colors.white,
                  child: Text(localizationHelper.localize('text_save')),
                  onPressed: () {
                    if (_lessonFormKey.currentState.validate() && _startTime != null && _endTime != null) {
                      _lessonFormKey.currentState.save();
                      Provider.of<LessonProvider>(context, listen: false).addLesson(Lesson(
                        id: null,
                        subject: _subject,
                        classroom: _classroom,
                        startHour: _startTime.hour,
                        startMinute: _startTime.minute,
                        endHour: _endTime.hour,
                        endMinute: _endTime.minute,
                        day: widget._day,
                      ));
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}