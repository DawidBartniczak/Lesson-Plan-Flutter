import 'package:flutter/material.dart';

class ChangePasswordBottomSheet extends StatefulWidget {
  final Function(String, String, String) _updatePasswordTapped;

  @override
  _ChangePasswordBottomSheetState createState() => _ChangePasswordBottomSheetState();

  ChangePasswordBottomSheet(this._updatePasswordTapped);
}

class _ChangePasswordBottomSheetState extends State<ChangePasswordBottomSheet> {
  final GlobalKey<FormState> _newPasswordFormKey = GlobalKey<FormState>();
  FocusNode _newPasswordFocusNode = FocusNode();
  FocusNode _newPasswordConfirmFocusNode = FocusNode();
  String _oldPassword;
  String _newPassword;
  String _newPasswordConfirm;

  @override
  void dispose() {
    _newPasswordFocusNode.dispose();
    _newPasswordConfirmFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _isTablet = MediaQuery.of(context).size.width > 600;

    return Padding(
      padding: EdgeInsets.all(!_isTablet ? 16 : 24),
      child: Form(
        key: _newPasswordFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              obscureText: true,
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(_newPasswordFocusNode),
              textInputAction: TextInputAction.next,
              decoration:
                  const InputDecoration(labelText: 'Stare hasło', filled: true),
              validator: (String value) {
                if (value.isEmpty) return 'Hasło jest wymagane.';
                if (value.length < 6)
                  return 'Hasło musi być dłuższe niż 6 znaków.';
                return null;
              },
              onSaved: (String input) => _oldPassword = input,
            ),
            SizedBox(
              height: !_isTablet ? 16 : 24,
            ),
            TextFormField(
              obscureText: true,
              focusNode: _newPasswordFocusNode,
              onFieldSubmitted: (_) => FocusScope.of(context)
                  .requestFocus(_newPasswordConfirmFocusNode),
              textInputAction: TextInputAction.next,
              decoration:
                  const InputDecoration(labelText: 'Nowe hasło', filled: true),
              validator: (String value) {
                if (value.isEmpty) return 'Hasło jest wymagane.';
                if (value.length < 6)
                  return 'Hasło musi być dłuższe niż 6 znaków.';
                return null;
              },
              onSaved: (String input) => _newPassword = input,
            ),
            SizedBox(
              height: !_isTablet ? 16 : 24,
            ),
            TextFormField(
              obscureText: true,
              focusNode: _newPasswordConfirmFocusNode,
              decoration: const InputDecoration(
                  labelText: 'Powtórz nowe hasło', filled: true),
              validator: (String value) {
                if (value.isEmpty) return 'Hasło jest wymagane.';
                if (value.length < 6)
                  return 'Hasło musi być dłuższe niż 6 znaków.';
                return null;
              },
              onSaved: (String input) => _newPasswordConfirm = input,
            ),
            SizedBox(
              height: 8,
            ),
            FlatButton(
              child: Text('Uaktualnij'),
              textColor: Theme.of(context).accentColor,
              onPressed: () {
                if (_newPasswordFormKey.currentState.validate()) {
                  _newPasswordFormKey.currentState.save();
                  widget._updatePasswordTapped(_oldPassword, _newPassword, _newPasswordConfirm);
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
