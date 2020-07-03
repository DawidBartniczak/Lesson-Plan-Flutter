import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import './helper/localizationHelper.dart';
import './model/addBottomSheet.dart';
import './provider/themeModeProvider.dart';
import './provider/lessonProvider.dart';
import './provider/homeworkProvider.dart';
import './provider/testProvider.dart';
import './screen/lessonPlan.dart';
import './screen/homework.dart';
import './screen/test.dart';
import './screen/settings.dart';
import './screen/lessonPlanEditor.dart';
import 'screen/subjectChooser.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: ThemeModeProvider(),
        ),
        ChangeNotifierProvider.value(
          value: LessonProvider(),
        ),
        ChangeNotifierProvider.value(
          value: HomeworkProvider(),
        ),
        ChangeNotifierProvider.value(
          value: TestProvider(),
        ),
      ],
      child: Consumer<ThemeModeProvider>(
        builder: (_, ThemeModeProvider themeModeProvider, _2) {
          return  MaterialApp(
            title: 'Lesson Plan',
            themeMode: themeModeProvider.themeMode,
            theme: ThemeData(
              primarySwatch: Colors.deepPurple,
              accentColor: Colors.deepPurpleAccent,
              iconTheme: IconThemeData(color: Colors.white,),
              cardTheme: CardTheme(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))
              ),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              toggleableActiveColor: Colors.deepPurple[300],
              accentColor: Colors.deepPurpleAccent[100],
              primaryColorDark: Colors.grey[900],
              primaryColorLight: Colors.grey[900],
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
              SubjectChooser.ROUTE_NAME: (_) => SubjectChooser(),
            },
          );
        }
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  TabController _tabController;
  int _index = 0;

  @override
  void initState() {
    Provider.of<LessonProvider>(context, listen: false).fetchLessons()
      .then((_) => Provider.of<HomeworkProvider>(context, listen: false).fetchHomework())
      .then((_) => Provider.of<TestProvider>(context, listen: false).fetchTests());
    _tabController = TabController(
      length: 3,
      initialIndex: 0,
      vsync: this,
    );
    _tabController.addListener(_updateIndex);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _updateIndex() {
    if (_index != _tabController.index)
      setState(() => _index = _tabController.index);
  }

  String _fabText(LocalizationHelper localizationHelper) {
    switch (_index) {
      case 0:
        return localizationHelper.localize('fab_edit_plan');
      case 1:
        return localizationHelper.localize('fab_add_homework');
      case 2:
        return localizationHelper.localize('fab_add_test');
      default:
        return '';
    }
  }
  
  @override
  Widget build(BuildContext context) {
    LocalizationHelper localizationHelper = LocalizationHelper.of(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(localizationHelper.localize('app_title')),
          bottom: TabBar(
            controller: _tabController,
            tabs: <Widget>[
              Tab(text: localizationHelper.localize('tab_lessonplan')),
              Tab(text: localizationHelper.localize('tab_homework')),
              Tab(text: localizationHelper.localize('tab_tests')),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            LessonPlanScreen(),
            HomeworkScreen(),
            TestScreen()
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.settings),
                color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
                tooltip: localizationHelper.localize('screen_settings'),
                onPressed: () => Navigator.of(context).pushNamed(Settings.ROUTE_NAME),
              ),
              IconButton(
                icon: Icon(Icons.calendar_today),
                color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
                tooltip: localizationHelper.localize('screen_calendar'),
                onPressed: () {},
              )
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton.extended(
          heroTag: 'main',
          icon: Icon(_index == 0 ? Icons.edit : Icons.add),
          label: Text(_fabText(localizationHelper)),
          onPressed: () {
            switch (_index) {
              case 0:
                Navigator.of(context).pushNamed(LessonPlanEditor.ROUTE_NAME);
                break;
              case 1:
                Navigator.of(context).pushNamed(SubjectChooser.ROUTE_NAME, arguments: AddBottomSheet.homeworkBottomSheet);
                break;
              case 2:
                Navigator.of(context).pushNamed(SubjectChooser.ROUTE_NAME, arguments: AddBottomSheet.testBottomSheet);
                break;
            }
          },
        ),
      ),
    );
  }
}