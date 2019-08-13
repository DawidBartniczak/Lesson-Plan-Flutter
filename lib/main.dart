import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './widget/menuFAB.dart';
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
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.deepPurpleAccent,
        iconTheme: IconThemeData(color: Colors.white,),
      ),
      home: HomeScreen(),
      routes: {
        'settings': (_) => Settings(),
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
        if (itemID == 1)
          Navigator.of(context).pushNamed('settings');
        else if (itemID == 2) 
          Navigator.of(context).pushNamed('settings');
      }, [
        FloatingActionButtonMenuItem(
          id: 1,
          tooltipText: 'Dodaj',
          itemIcon: Icons.add
        ),
        FloatingActionButtonMenuItem(
          id: 2,
          tooltipText: 'Ustawienia',
          itemIcon: Icons.settings
        )
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabController.index,
        // backgroundColor: Theme.of(context).primaryColor,
        // selectedItemColor: Colors.white,
        // unselectedItemColor: Colors.green[200],
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            title: Text('Plan Lekcji'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Zadania Domowe'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            title: Text('Sprawdziany'),
          )
        ],
        onTap: (int index) => setState(() => _tabController.animateTo(index)),
      ),
    );
  }
}