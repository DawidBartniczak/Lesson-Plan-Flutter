import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import './model/localizationHelper.dart';
import './model/admobHelper.dart';
import './screen/lessonPlan.dart';
import './screen/homework.dart';
import './screen/test.dart';
import './screen/settings.dart';
import './screen/lessonPlanEditor.dart';
import './screen/lessonDetails.dart';

void main() {
  runApp(MyApp());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lesson Plan',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.deepPurpleAccent,
        iconTheme: IconThemeData(color: Colors.white,),
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))
        )
      ),
      supportedLocales: [
        Locale('en', 'US'),
        Locale('pl', 'PL'),
      ],
      localizationsDelegates: [
        LocalizationHelper.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      localeResolutionCallback: (Locale locale, Iterable<Locale> supportedLocales) {
        if (locale == null)
          return supportedLocales.first;

        for (Locale supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode)
            return supportedLocale;
        }
        return supportedLocales.first;
      },
      home: HomeScreen(),
      routes: {
        Settings.ROUTE_NAME: (_) => Settings(),
        LessonPlanEditor.ROUTE_NAME: (_) => LessonPlanEditor(),
        LessonDetails.ROUTE_NAME: (_) => LessonDetails()
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    AdMobHelper.showBanner();
    super.initState();
  }

  @override
  void dispose() {
    AdMobHelper.hideBanner();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LocalizationHelper localizationHelper = LocalizationHelper.of(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(localizationHelper.localize('app_title')),
          actions: <Widget>[
            PopupMenuButton(
              onSelected: (int value) {
                switch (value) {
                  case 1:
                    Navigator.of(context).pushNamed(Settings.ROUTE_NAME);
                    break;
                  case 2:
                    Navigator.of(context).pushNamed(LessonPlanEditor.ROUTE_NAME);
                    break;
                }
              },
              itemBuilder: (_) {
                return [
                  PopupMenuItem(
                    child: Text(localizationHelper.localize('screen_lessonplaneditor')),
                    value: 2,
                  )
                ];
              },
            )
          ],
          bottom: TabBar(
            tabs: <Widget>[
              Tab(text: localizationHelper.localize('tab_lessonplan')),
              Tab(text: localizationHelper.localize('tab_homwork')),
              Tab(text: localizationHelper.localize('tab_tests')),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            LessonPlanScreen(),
            HomeworkScreen(),
            TestScreen()
          ],
        ),
      ),
    );
  }
}