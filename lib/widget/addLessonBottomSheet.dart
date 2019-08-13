import 'package:flutter/material.dart';

class AddLessonBottomSheet extends StatefulWidget {
  @override
  _AddLessonBottomSheetState createState() => _AddLessonBottomSheetState();
}

class _AddLessonBottomSheetState extends State<AddLessonBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    bool _isTablet = MediaQuery.of(context).size.width > 600;

    return Padding(
      padding: EdgeInsets.all(!_isTablet ? 16 : 24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              keyboardAppearance: Brightness.light,
              decoration: InputDecoration(
                labelText: 'Lekcja',
                filled: true
              ),
            ),
            SizedBox(height: !_isTablet ? 16 : 24,),
            TextFormField(
              keyboardAppearance: Brightness.light,
              decoration: InputDecoration(
                labelText: 'Klasa',
                filled: true
              ),
            ),
            SizedBox(height: !_isTablet ? 16 : 24,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Godzina początku lekcji:'),
                FlatButton(
                  child: Text('Wybierz'),
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(height: !_isTablet ? 8 : 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Godzina końca lekcji:'),
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
              onPressed: () => Navigator.pop(context),
            )
          ],
        ),
      ),
    );
  }
}