import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  static const ROUTE_NAME = 'settings';
  
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
        title: const Text('Ustawienia'),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child:
                Text('Aplikacja', style: _theme.textTheme.subtitle),
          ),
          ListTile(
            title: const Text('Siedmo dniowy plan'),
            subtitle: const Text('Plan lekcji obejmujący weekend.'),
            trailing: Switch(
              value: _sevenDayPlan,
              onChanged: (bool newValue) =>
                  setState(() => _sevenDayPlan = newValue),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child:
                Text('Zerowanie', style: _theme.textTheme.subtitle),
          ),
          InkWell(
            onTap: () {},
            child: const ListTile(
              title: const Text('Reset', style: TextStyle(color: Colors.red),),
              subtitle: const Text('Usuń dane z tego urządzenia.'),
            ),
          ),
          const Divider()
        ],
      ),
    );
  }
}
