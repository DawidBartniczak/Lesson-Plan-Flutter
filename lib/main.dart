import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './widget/menuFAB.dart';
import './screen/register.dart';
import './screen/login.dart';
import './screen/lessonPlan.dart';
import './screen/homework.dart';
import './screen/test.dart';
import './screen/settings.dart';

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
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        accentColor: Colors.deepOrangeAccent,
        bottomAppBarColor: Colors.green,
        iconTheme: IconThemeData(color: Colors.white,),
      ),
      home: StreamBuilder<FirebaseUser>(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (_, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.hasData)
            return HomeScreen();
          else
            return Register();
        },
      ),
      routes: {
        'login': (_) => Login(),
        'settings': (_) => Settings()
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
      vsync: this,
      length: 3
    );
    super.initState();
  }

  String tabBarText() {
    if (_tabController.index == 0)
      return 'Plan Lekcji';
    else if (_tabController.index == 1)
      return 'Zadania Domowe';
    else if (_tabController.index == 2)
      return 'Testy';
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tabBarText()),
      ),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: <Widget>[
          LessonPlanScreen(),
          HomeworkScreen(),
          TestScreen()
        ],
      ),
      floatingActionButton: FloatingActionButtonMenu((int itemID) {
        _tabController.animateTo(itemID - 1);
        setState(() {});
      }, [
        FloatingActionButtonMenuItem(
          id: 1,
          tooltipText: 'Plan Lekcji',
          itemIcon: Icons.calendar_today
        ),
        FloatingActionButtonMenuItem(
          id: 2,
          tooltipText: 'Zadania Domowe',
          itemIcon: Icons.home
        ),
        FloatingActionButtonMenuItem(
          id: 3,
          tooltipText: 'Sprawdziany',
          itemIcon: Icons.library_books
        )
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              tooltip: 'Add',
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.settings),
              tooltip: 'Ustawienia',
              onPressed: () => Navigator.of(context).pushNamed('settings'),
            )
          ],
        ),
      ),
    );
  }
}