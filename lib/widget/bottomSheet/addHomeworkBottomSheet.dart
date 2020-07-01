import 'package:flutter/material.dart';
import 'package:lessonplan/provider/homeworkProvider.dart';
import 'package:provider/provider.dart';
import 'package:select_dialog/select_dialog.dart';
import 'package:intl/intl.dart';

import '../../helper/localizationHelper.dart';
import '../../model/homework.dart';
import '../../model/lesson.dart';

class AddHomeworkBottomSheet extends StatefulWidget {
  final List<Lesson> _lessonsForSubject;

  @override
  _AddHomeworkBottomSheetState createState() => _AddHomeworkBottomSheetState();

  AddHomeworkBottomSheet(this._lessonsForSubject);
}

class _AddHomeworkBottomSheetState extends State<AddHomeworkBottomSheet> {
  final GlobalKey<FormState> _homeworkFormKey = GlobalKey<FormState>();
  Map<String, DateTime> _possibleDates = Map();
  Map<String, int> _ids = Map();
  String _homeworkContent;
  String _selectedDateString = "";
  bool _datePicked = false;

  void _pickDate(LocalizationHelper localizationHelper) {
    _generateDates(localizationHelper);
    List<String> possibleDatesStrings = _possibleDates.keys.toList();
    possibleDatesStrings.sort((String a, String b) {
      int aDate = _possibleDates[a].millisecondsSinceEpoch;
      int bDate = _possibleDates[b].millisecondsSinceEpoch;

      return aDate.compareTo(bDate);
    });

    SelectDialog.showModal<String>(
      context,
      showSearchBox: false,
      selectedValue: _selectedDateString,
      label: localizationHelper.localize('text_select_lesson'),
      items: possibleDatesStrings,
      onChange: (String selected) {
        setState(() {
          _selectedDateString = selected;
          _datePicked = true;
        });
      }
    );
  }

  void _generateDates(LocalizationHelper localizationHelper) {
    if (_possibleDates.length != 0)
      return;

    widget._lessonsForSubject.forEach((Lesson lesson) {
      DateTime firstLessonDate = DateTime.now()
        .subtract(Duration(days: DateTime.now().weekday - lesson.day));
      
      if (firstLessonDate.isAfter(DateTime.now())) {
        String firstLessonString = DateFormat('dd.MM').format(firstLessonDate) + ' - ' + localizationHelper.localize('day_${lesson.day}');
        _possibleDates.putIfAbsent(firstLessonString, () => firstLessonDate);
        _ids.putIfAbsent(firstLessonString, () => lesson.id);
      }
      String secondLessonString = DateFormat('dd.MM').format(firstLessonDate.add(Duration(days: 7))) + ' - ' + localizationHelper.localize('day_${lesson.day}');
      String thirdLessonString = DateFormat('dd.MM').format(firstLessonDate.add(Duration(days: 14))) + ' - ' + localizationHelper.localize('day_${lesson.day}');
      _possibleDates.putIfAbsent(secondLessonString, () => firstLessonDate.add(Duration(days: 7)));
      _possibleDates.putIfAbsent(thirdLessonString, () => firstLessonDate.add(Duration(days: 14)));
      _ids.putIfAbsent(secondLessonString, () => lesson.id);
      _ids.putIfAbsent(thirdLessonString, () => lesson.id);
    });
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
                SizedBox(height: !_isTablet ? 16 : 24,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(!_datePicked 
                      ? localizationHelper.localize('text_select_lesson')
                      : _selectedDateString),
                    FlatButton(
                      child: Text(localizationHelper.localize('text_select')),
                      onPressed: () => _pickDate(localizationHelper),
                    ),
                  ],
                ),
                SizedBox(height: !_isTablet ? 8 : 16,),
                RaisedButton(
                  color: Theme.of(context).accentColor,
                  textColor: Colors.white,
                  child: Text(localizationHelper.localize('text_save')),
                  onPressed: () {
                    if (_homeworkFormKey.currentState.validate() && _datePicked) {
                      _homeworkFormKey.currentState.save();
                      Homework homework = Homework(
                        name: _homeworkContent,
                        lessonID: _ids[_selectedDateString],
                        date: _possibleDates[_selectedDateString],
                      );
                      Provider.of<HomeworkProvider>(context, listen: false).addHomework(homework)
                        .then((_) => Navigator.of(context).pop(true));
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