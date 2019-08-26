import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      title: 'Plan Lekcji',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.deepPurpleAccent,
        iconTheme: IconThemeData(color: Colors.white,),
      ),
      builder: (BuildContext context, Widget home) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: home,
        );
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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Plan Lekcji'),
          actions: <Widget>[
            PopupMenuButton(
              onSelected: (int value) {
                switch (value) {
                  case 1:
                    Navigator.of(context).pushNamed(Settings.ROUTE_NAME);
                    break;
                  case 2:
                    Navigator.of(context).pushNamed(LessonPlanEditor.ROUTE_NAME)
                      .then((_) {
                        AdMobHelper.showBanner();
                      });
                    break;
                }
              },
              itemBuilder: (_) {
                return [
                  PopupMenuItem(
                    child: Text('Ustawienia'),
                    value: 1,
                  ),
                  PopupMenuItem(
                    child: Text('Edytor Planu'),
                    value: 2,
                  )
                ];
              },
            )
          ],
          bottom: TabBar(
            tabs: <Widget>[
              Tab(text: 'Plan Lekcji'),
              Tab(text: 'Zad. Domowe'),
              Tab(text: 'Sprawdziany'),
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