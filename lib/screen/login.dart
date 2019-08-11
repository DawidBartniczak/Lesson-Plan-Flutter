import 'package:flutter/material.dart';
import 'package:validators/validators.dart';

import '../widget/progressIndicator.dart';
import '../model/userRegister.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _passwordFocus = FocusNode();
  bool _isLoading = false;
  String _email;
  String _password;

  @override
  void dispose() {
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData _mediaQuery = MediaQuery.of(context);
    final _isTablet = _mediaQuery.size.width > 600;

    return Scaffold(
      appBar: AppBar(title: Text('Logowanie'),),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AnimatedProgressIndicator(_isLoading, _mediaQuery.size.width),
          Padding(
            padding: EdgeInsets.all(!_isTablet ? 16 : 24),
            child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  textCapitalization: TextCapitalization.none,
                  autocorrect: false,
                  decoration:
                      const InputDecoration(labelText: 'E-Mail', filled: true),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_passwordFocus),
                  validator: (String value) {
                    if (value.isEmpty) return 'Adres E-Mail jest wymagany.';
                    if (!isEmail(value)) return 'E-Mail nie jest prawidłowy.';
                    return null;
                  },
                  onSaved: (String input) => _email = input,
                ),
                SizedBox(
                  height: !_isTablet ? 16 : 24,
                ),
                TextFormField(
                  obscureText: true,
                  keyboardType: TextInputType.emailAddress,
                  focusNode: _passwordFocus,
                  decoration:
                      const InputDecoration(labelText: 'Hasło', filled: true),
                  validator: (String value) {
                    if (value.isEmpty) return 'Hasło jest wymagane.';
                    if (value.length < 6)
                      return 'Hasło musi być dłuższe niż 6 znaków.';
                    return null;
                  },
                  onSaved: (String input) => _password = input,
                ),
                SizedBox(
                  height: 8,
                ),
                RaisedButton(
                  child: Text('ZALOGUJ'),
                  textColor: Colors.white,
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();

                      if (!_isLoading) {
                        setState(() {
                          _isLoading = true;
                        });
                        loginWithPassword(context, _email, _password)
                            .then((_) {
                          setState(() {
                            _isLoading = false;
                          });
                        });
                      }
                    }
                  },
                  color: Theme.of(context).accentColor,
                ),
              ],
            ),
          ),
          )
        ],
      ),
    );
  }
}