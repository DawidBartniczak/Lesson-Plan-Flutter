import 'package:flutter/material.dart';

class Login extends StatelessWidget {
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
                padding: EdgeInsets.only(top: _mediaQuery.size.height * 0.25 - 50),
                child: Card(
                  child: Container(
                    width: !_isTablet ? _mediaQuery.size.width - 16 : 450,
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
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final _isTablet = MediaQuery.of(context).size.width > 600;

    return Padding(
      padding: EdgeInsets.all(!_isTablet ? 16 : 24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: 'E-Mail', filled: true),
            ),
            SizedBox(
              height: !_isTablet ? 16 : 24,
            ),
            TextFormField(
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: 'Hasło', filled: true),
            ),
            SizedBox(
              height: !_isTablet ? 8 : 16,
            ),
            RaisedButton(
              child: Text('ZAREJESTRUJ'),
              textColor: Colors.white,
              onPressed: () {},
              color: Theme.of(context).accentColor,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    child: Text('GOOGLE'),
                    textColor: Colors.white,
                    onPressed: () {},
                    color: Color.fromARGB(255, 66, 133, 244),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: RaisedButton(
                    child: Text('FACEBOOK'),
                    textColor: Colors.white,
                    onPressed: () {},
                    color: Color.fromARGB(255, 59, 89, 152),
                  ),
                )
              ],
            )
          ],
        ),
      ),
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
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}
