import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _sevenDayPlan = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ustawienia'),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Text('Konto', style: Theme.of(context).textTheme.subtitle),
          ),
          InkWell(
            onTap: () {},
            child: ListTile(
              title: Text('Opcje Konta'),
              subtitle: Text('Zarządzaj swoim kontem.'),
              trailing: Icon(Icons.keyboard_arrow_right),
            ),
          ),
          InkWell(
            onTap: () {},
            child: ListTile(
              title: Text('Opcje Klasy'),
              subtitle: Text('Zarządzaj i dołączaj do klas.'),
              trailing: Icon(Icons.keyboard_arrow_right),
            ),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child:
                Text('Aplikacja', style: Theme.of(context).textTheme.subtitle),
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
                Text('Zerowanie', style: Theme.of(context).textTheme.subtitle),
          ),
          InkWell(
            onTap: () {
              FirebaseAuth.instance.signOut()
                .then((_) {
                  Navigator.of(context).pop();
                });
            },
            child: ListTile(
              title: Text('Wyloguj', style: TextStyle(color: Colors.red),),
              subtitle: Text('Usuń konto z tego urządzenia.'),
            ),
          ),
          Divider()
        ],
      ),
    );
  }
}
