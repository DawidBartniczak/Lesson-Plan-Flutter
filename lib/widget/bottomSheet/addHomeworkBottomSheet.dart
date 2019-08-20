import 'package:flutter/material.dart';

import '../../model/homework.dart';

class AddHomeworkBottomSheet extends StatefulWidget {
  @override
  _AddHomeworkBottomSheetState createState() => _AddHomeworkBottomSheetState();
}

class _AddHomeworkBottomSheetState extends State<AddHomeworkBottomSheet> {
  final GlobalKey<FormState> _homeworkFormKey = GlobalKey<FormState>();

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