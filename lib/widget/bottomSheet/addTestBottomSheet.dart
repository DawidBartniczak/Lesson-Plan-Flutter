import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:select_dialog/select_dialog.dart';

import '../../provider/testProvider.dart';
import '../../helper/localizationHelper.dart';
import '../../model/test.dart';
import '../../model/lesson.dart';

class AddTestBottomSheet extends StatefulWidget {
  final List<Lesson> _lessonsForSubject;

  @override
  _AddTestBottomSheetState createState() => _AddTestBottomSheetState();

  AddTestBottomSheet(this._lessonsForSubject);
}

class _AddTestBottomSheetState extends State<AddTestBottomSheet> {
  final GlobalKey<FormState> _testFormKey = GlobalKey<FormState>();
  Map<String, DateTime> _possibleDates = Map();
  Map<String, int> _ids = Map();
  String _testContent;
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
            key: _testFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  keyboardAppearance: Brightness.light,
                  decoration: InputDecoration(
                    labelText: localizationHelper.localize('text_test_subject'),
                    filled: true
                  ),
                  validator: (String value) {
                    if (value.isEmpty)
                      return localizationHelper.localize('error_subjectempty');
                    return null;
                  },
                  onSaved: (String value) => _testContent = value,
                ),
                SizedBox(height: !_isTablet ? 16 : 24,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(!_datePicked 
                      ? localizationHelper.localize('text_selectdate')
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
                    if (_testFormKey.currentState.validate() && _datePicked) {
                      _testFormKey.currentState.save();
                      Test test = Test(
                        name: _testContent,
                        lessonID: _ids[_selectedDateString],
                        date: _possibleDates[_selectedDateString],
                      );
                      Provider.of<TestProvider>(context, listen: false).addTest(test)
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