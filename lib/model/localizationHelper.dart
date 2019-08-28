import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LocalizationHelper {
  static const _LocalizationHelperDelegate delegate = _LocalizationHelperDelegate();
  final Locale locale;
  Map<String, String> _localizedStrings;

  static LocalizationHelper of(BuildContext context) {
    return Localizations.of(context, LocalizationHelper);
  }

  Future loadStrings() async {
    String jsonString = 
      await rootBundle.loadString('lang/${locale.languageCode}.json');
    print('Locale Path: lang/${locale.languageCode}.json');
    Map<String, dynamic> jsonData = json.decode(jsonString);

    _localizedStrings = jsonData.map((String key, dynamic value) {
      return MapEntry(key, value.toString());
    });
  }

  String localize(String key) {
    return _localizedStrings[key];
  }

  LocalizationHelper(this.locale);
}

class _LocalizationHelperDelegate extends LocalizationsDelegate<LocalizationHelper> {
  const _LocalizationHelperDelegate();

  @override
  bool isSupported(Locale locale) {
    //print(locale.countryCode);
    return ['en', 'pl'].contains(locale.languageCode);
  }

  @override
  Future<LocalizationHelper> load(Locale locale) async {
    print(locale);
    LocalizationHelper localizationHelper = LocalizationHelper(locale);
    await localizationHelper.loadStrings();
    return localizationHelper;
  }

  @override
  bool shouldReload(LocalizationsDelegate<LocalizationHelper> old) => false;
}