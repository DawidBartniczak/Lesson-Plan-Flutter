import 'package:flutter/material.dart';
import 'package:validators/validators.dart';

import '../model/userRegister.dart';
import '../widget/progressIndicator.dart';

class Register extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MediaQueryData _mediaQuery = MediaQuery.of(context);
    final ThemeData _theme = Theme.of(context);
    final _isTablet = _mediaQuery.size.width > 600;

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Container(
                width: double.infinity,
                height: _mediaQuery.size.height * 0.25,
                color: _theme.primaryColor,
              ),
              Padding(
                padding:
                    EdgeInsets.only(top: _mediaQuery.size.height * 0.25 - 50),
                child: Card(
                  child: Container(
                    width: !_isTablet ? _mediaQuery.size.width - 24 : 425,
                    child: LoginForm(),
                  ),
                ),
              )
            ],
          ),
          LoginBottom()
        ],
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
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
    final _isTablet = MediaQuery.of(context).size.width > 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AnimatedProgressIndicator(_isLoading, !_isTablet ? MediaQuery.of(context).size.width - 24 : 425),
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
                  child: Text('ZAREJESTRUJ'),
                  textColor: Colors.white,
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();

                      if (!_isLoading) {
                        setState(() {
                          _isLoading = true;
                        });
                        registerWithPassword(context, _email, _password)
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
                Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        child: Text('GOOGLE'),
                        textColor: Colors.white,
                        onPressed: () {
                          if (!_isLoading) {
                            setState(() {
                              _isLoading = true;
                            });
                            authenticateWithGoogle(context)
                                .then((_) {
                              setState(() {
                                _isLoading = false;
                              });
                            });
                          }
                        },
                        color: Color.fromARGB(255, 66, 133, 244),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: RaisedButton(
                        child: Text('FACEBOOK'),
                        textColor: Colors.white,
                        onPressed: () {
                          if (!_isLoading) {
                            setState(() {
                              _isLoading = true;
                            });
                            authenticateWithFacebook(context)
                                .then((_) {
                              setState(() {
                                _isLoading = false;
                              });
                            });
                          }
                        },
                        color: Color.fromARGB(255, 59, 89, 152),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class LoginBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _isTablet = MediaQuery.of(context).size.width > 600;

    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.grey[200],
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: !_isTablet ? 16 : 24, vertical: !_isTablet ? 4 : 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Masz już konto?'),
            FlatButton(
              child: Text('ZALOGUJ SIĘ'),
              onPressed: () => Navigator.of(context).pushNamed('login'),
            )
          ],
        ),
      ),
    );
  }
}
