import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../model/databaseHelper.dart';
import '../model/lesson.dart';

class LessonProvider extends ChangeNotifier {
  List<Lesson> _lessons = [];

  List<Lesson> get lessons => _lessons;

  Future<void> fetchLessons() async {
    sqflite.Database database = await DatabaseHelper().database;

    List<Map<String, dynamic>> lessonsData = await database.query(Lesson.TABLE_NAME,
      columns: [Lesson.ID, Lesson.SUBJECT, Lesson.CLASSROOM, Lesson.START_HOUR, Lesson.START_MINUTE, Lesson.END_HOUR, Lesson.END_MINUTE, Lesson.DAY]
    );
    _lessons = lessonsData.map((Map rawLesson) => Lesson.fromMap(rawLesson)).toList();
    
    notifyListeners();
  }

  List<Lesson> lessonsForDay(int day) => _lessons.where((Lesson lesson) => lesson.day == day).toList();
}