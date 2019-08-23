import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/test.dart';

class AddTestBottomSheet extends StatefulWidget {
  final Function(Test) _addToDatabase;
  final int _day;
  final int _lessonID;

  @override
  _AddTestBottomSheetState createState() => _AddTestBottomSheetState();

  AddTestBottomSheet(this._addToDatabase, this._day, this._lessonID);
}

class _AddTestBottomSheetState extends State<AddTestBottomSheet> {
  final GlobalKey<FormState> _homeworkFormKey = GlobalKey<FormState>();
  String _testContent;
  DateTime _testDate;
  bool _datePicked = false;

  void _pickDate() {
    showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 31)),
      initialDate: DateTime.now(),
    ).then((DateTime pickedDate) {
      if (pickedDate == null)
        return;
      if (pickedDate.weekday == widget._day) {
        setState(() {
          _testDate = pickedDate;
          _datePicked = true;
        });
      } else {
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              title: const Text('Zła data!'),
              content: const Text('Tej lekcji nie ma w wybranym dniu.'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Zamknij'),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            );
          }
        );
      }
    });
  }

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
              decoration: const InputDecoration(
                labelText: 'Temat do sprawdzianu.',
                filled: true
              ),
              validator: (String value) {
                if (value.isEmpty)
                  return 'Temat jest wymagany';
                return null;
              },
              onSaved: (String value) => _testContent = value,
            ),
            SizedBox(height: !_isTablet ? 16 : 24,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(!_datePicked 
                  ? 'Wybierz datę:' 
                  : 'Wybrana data: ${DateFormat('dd.MM').format(_testDate)}'),
                FlatButton(
                  child: const Text('Wybierz'),
                  onPressed: _pickDate,
                ),
              ],
            ),
            SizedBox(height: !_isTablet ? 8 : 16,),
            RaisedButton(
              color: Theme.of(context).accentColor,
              textColor: Colors.white,
              child: const Text('Zapisz'),
              onPressed: () {
                if (_homeworkFormKey.currentState.validate() && _datePicked) {
                  _homeworkFormKey.currentState.save();
                  widget._addToDatabase(Test(
                    id: null,
                    lessonID: widget._lessonID,
                    name: _testContent,
                    date: _testDate
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