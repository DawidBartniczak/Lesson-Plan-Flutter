import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/localizationHelper.dart';
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
        title: Text(LocalizationHelper.of(context).localize('screen_settings')),
      ),
      body: ListView(
        children: <Widget>[
          Consumer<ThemeModeProvider>(
            builder: (BuildContext context, ThemeModeProvider themeModeProvider, _) {
              LocalizationHelper localizationHelper = LocalizationHelper.of(context);
              ThemeMode themeMode = themeModeProvider.themeMode;

              return ExpansionTile(
                title: Text(localizationHelper.localize('settings_theme_header')),
                subtitle: Text(localizationHelper.localize('settings_theme_description')),
                children: <Widget>[
                  ListTile(
                    title: Text(localizationHelper.localize('settings_theme_sysdefined_header')),
                    subtitle: Text(localizationHelper.localize('settings_theme_sysdefined_description')),
                    leading: Radio(
                      value: ThemeMode.system,
                      groupValue: themeMode,
                      onChanged: themeModeProvider.changeThemeMode,
                    ),
                  ),
                  ListTile(
                    title: Text(localizationHelper.localize('settings_theme_light_header')),
                    subtitle: Text(localizationHelper.localize('settings_theme_light_description')),
                    leading: Radio(
                      value: ThemeMode.light,
                      groupValue: themeMode,
                      onChanged: themeModeProvider.changeThemeMode,
                    ),
                  ),
                  ListTile(
                    title: Text(localizationHelper.localize('settings_theme_dark_header')),
                    subtitle: Text(localizationHelper.localize('settings_theme_dark_description')),
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
