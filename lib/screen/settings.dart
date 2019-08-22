import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _sevenDayPlan = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Ustawienia'),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child:
                Text('Aplikacja', style: _theme.textTheme.subtitle),
          ),
          ListTile(
            title: Text('Siedmo dniowy plan'),
            subtitle: Text('Plan lekcji obejmujący weekend.'),
            trailing: Switch(
              value: _sevenDayPlan,
              onChanged: (bool newValue) =>
                  setState(() => _sevenDayPlan = newValue),
            ),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child:
                Text('Zerowanie', style: _theme.textTheme.subtitle),
          ),
          InkWell(
            onTap: () {},
            child: ListTile(
              title: Text('Reset', style: TextStyle(color: Colors.red),),
              subtitle: Text('Usuń dane z tego urządzenia.'),
            ),
          ),
          Divider()
        ],
      ),
    );
  }
}
