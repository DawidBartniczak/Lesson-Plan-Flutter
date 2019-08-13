import 'package:flutter/material.dart';
import 'package:validators/validators.dart';

class ChangeEmailBottomSheet extends StatefulWidget {
  final Function(String, String) _updateEmailTapped;

  @override
  _ChangeEmailBottomSheetState createState() => _ChangeEmailBottomSheetState();

  ChangeEmailBottomSheet(this._updateEmailTapped);
}

class _ChangeEmailBottomSheetState extends State<ChangeEmailBottomSheet> {
  final GlobalKey<FormState> _newEmailFormKey = GlobalKey<FormState>();
  FocusNode _newEmailFocusNode = FocusNode();
  String _password;
  String _newEmail;

  @override
  void dispose() {
    _newEmailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _isTablet = MediaQuery.of(context).size.width > 600;

    return Padding(
      padding: EdgeInsets.all(!_isTablet ? 16 : 24),
      child: Form(
        key: _newEmailFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              obscureText: true,
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(_newEmailFocusNode),
              textInputAction: TextInputAction.next,
              decoration:
                  const InputDecoration(labelText: 'Stare hasło', filled: true),
              validator: (String value) {
                if (value.isEmpty) return 'Hasło jest wymagane.';
                if (value.length < 6)
                  return 'Hasło musi być dłuższe niż 6 znaków.';
                return null;
              },
              onSaved: (String input) => _password = input,
            ),
            SizedBox(
              height: !_isTablet ? 16 : 24,
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              textCapitalization: TextCapitalization.none,
              autocorrect: false,
              decoration:
                  const InputDecoration(labelText: 'Nowy E-Mail', filled: true),
              validator: (String value) {
                if (value.isEmpty) return 'Adres E-Mail jest wymagany.';
                if (!isEmail(value)) return 'E-Mail nie jest prawidłowy.';
                return null;
              },
              onSaved: (String input) => _newEmail = input,
            ),
            SizedBox(
              height: 8,
            ),
            FlatButton(
              child: Text('Uaktualnij'),
              textColor: Theme.of(context).accentColor,
              onPressed: () {
                if (_newEmailFormKey.currentState.validate()) {
                  _newEmailFormKey.currentState.save();
                  widget._updateEmailTapped(_password, _newEmail);
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
