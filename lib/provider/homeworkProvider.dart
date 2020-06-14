import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../model/databaseHelper.dart';
import '../model/homework.dart';
import '../model/lesson.dart';

class HomeworkProvider with ChangeNotifier {
  List<Homework> _homework = [];

  List<Homework> get homework => _homework;

  Future<void> fetchHomework() async {
    sqflite.Database database = await DatabaseHelper().database;

    List<Map<String, dynamic>> homeworkData = await database.query(Homework.TABLE_NAME);
    _homework = homeworkData
      .map((Map rawHomework) => Homework.fromMap(rawHomework))
      .where((Homework homework) => homework.date.isAfter(DateTime.now()))
      .toList();
    
    notifyListeners();
  }

  Future<void> addHomework(Homework homework) async {
    sqflite.Database database = await DatabaseHelper().database;

    homework.id = await database.insert(Homework.TABLE_NAME, homework.toMap());
    _homework.add(homework);

    notifyListeners();
  }
}