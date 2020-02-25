import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/themeModeProvider.dart';
import '../model/admobHelper.dart';

class Settings extends StatefulWidget {
  static const ROUTE_NAME = 'settings';
  
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  @override
  void initState() {
    AdMobHelper.hideBanner();
    super.initState();
  }

  @override
  void dispose() {
    AdMobHelper.showBanner();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ustawienia'),
      ),
      body: ListView(
        children: <Widget>[
          Consumer<ThemeModeProvider>(
            builder: (BuildContext context, ThemeModeProvider themeModeProvider, _) {
              ThemeMode themeMode = themeModeProvider.themeMode;

              return ExpansionTile(
                title: Text('Theme'),
                subtitle: Text('Change theme of the app.'),
                children: <Widget>[
                  ListTile(
                    title: Text('System Defined'),
                    subtitle: Text(
                      Platform.isAndroid 
                        ? 'Will use your system\'s default theme (Android Q+)'
                        : 'Will use your system\'s default theme (iOS 13+)' ,
                    ),
                    leading: Radio(
                      value: ThemeMode.system,
                      groupValue: themeMode,
                      onChanged: themeModeProvider.changeThemeMode,
                    ),
                  ),
                  ListTile(
                    title: Text('Light'),
                    subtitle: Text('Will use Light Mode'),
                    leading: Radio(
                      value: ThemeMode.light,
                      groupValue: themeMode,
                      onChanged: themeModeProvider.changeThemeMode,
                    ),
                  ),
                  ListTile(
                    title: Text('Dark'),
                    subtitle: Text('Will use Dark Mode'),
                    leading: Radio(
                      value: ThemeMode.dark,
                      groupValue: themeMode,
                      onChanged: themeModeProvider.changeThemeMode,
                    ),
                  ),
                ],
              );
            }
          ),
        ],
      ),
    );
  }
}
