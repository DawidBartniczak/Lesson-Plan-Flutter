import 'package:flutter/material.dart';

import '../../model/homework.dart';

class AddTestBottomSheet extends StatefulWidget {
  @override
  _AddTestBottomSheetState createState() => _AddTestBottomSheetState();
}

class _AddTestBottomSheetState extends State<AddTestBottomSheet> {
  final GlobalKey<FormState> _homeworkFormKey = GlobalKey<FormState>();
  String _testContent;
  DateTime _testDate;
  bool _datePicked = false;

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
                labelText: 'Temat do sprawdzianu.',
                filled: true
              ),
            ),
            SizedBox(height: !_isTablet ? 16 : 24,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(!_datePicked 
                  ? 'Data sprawdzianu:' 
                  : 'Wybrana data:'),
                FlatButton(
                  child: Text('Wybierz'),
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(height: !_isTablet ? 8 : 16,),
            RaisedButton(
              color: Theme.of(context).accentColor,
              textColor: Colors.white,
              child: Text('Zapisz'),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}