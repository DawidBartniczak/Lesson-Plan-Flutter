import 'package:flutter/material.dart';

import '../model/databaseHelper.dart';
import '../model/localizationHelper.dart';
import '../model/lesson.dart';
import '../screen/lessonDetails.dart';

class LessonPlanScreen extends StatefulWidget {
  @override
  _LessonPlanScreenState createState() => _LessonPlanScreenState();
}

class _LessonPlanScreenState extends State<LessonPlanScreen> {
  DatabaseHelper _databaseHelper = DatabaseHelper();
  Future<List<Lesson>> _lessons;
  int day = 1;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  void loadData() {
    setState(() {
      _lessons = _databaseHelper.getLessonsForDay(day);
    });
  }

  Widget _buildTabletLessonGrid(List<Lesson> lessons) {
    return GridView(
      padding: const EdgeInsets.all(24.0),
      children: lessons.map((Lesson lesson) {
        return Card(
          child: InkWell(
            onTap: () => Navigator.of(context).pushNamed(LessonDetails.ROUTE_NAME, arguments: lesson),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5.0),
                        topRight: Radius.circular(5.0),
                      )
                    ),
                    alignment: Alignment.center,
                    child: Text(lesson.classroom,
                      style: TextStyle(
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  title: Text(lesson.subject),
                  subtitle: Text('${lesson.startHour}:${lesson.startMinute} - ${lesson.endHour}:${lesson.endMinute}'),
                )
              ],
            ),
          ),
        );
      }).toList(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0
      ),
    );
  }

  Widget _buildPhoneLessonList(List<Lesson> lessons) {
    return ListView(
      children: lessons.map((Lesson lesson) {
        return InkWell(
          onTap: () => Navigator.of(context).pushNamed(LessonDetails.ROUTE_NAME, arguments: lesson),
          child: ListTile(
            title: Text(lesson.subject),
            subtitle: Text('${lesson.startHour}:${lesson.startMinute} - ${lesson.endHour}:${lesson.endMinute}'),
            leading: CircleAvatar(
              radius: 24,
              child: Text(lesson.classroom),
            ),
          ),
        );
      }).toList()
    );
  }

  Widget _buildDayChanger(BuildContext context) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.keyboard_arrow_left),
            color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
            onPressed: () {
              if (day != 1)
                day--;
                loadData();
            },
          ),
          Text(LocalizationHelper.of(context).localize('day_$day')),
          IconButton(
            icon: Icon(Icons.keyboard_arrow_right),
            color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
            onPressed: () {
              if (day != 5)
                day++;
                loadData();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool _isTablet = MediaQuery.of(context).size.width > 600;

    return FutureBuilder(
      future: _lessons,
      builder: (_, AsyncSnapshot<List<Lesson>> snapshot) {
        if (snapshot.hasData) {
          List<Lesson> lessons = snapshot.data;

          return Column(
            children: <Widget>[
              _buildDayChanger(context),
              Expanded(
                child: !_isTablet 
                  ? _buildPhoneLessonList(lessons)
                  : _buildTabletLessonGrid(lessons),
              )
            ],
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}