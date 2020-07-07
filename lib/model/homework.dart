import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../helper/databaseHelper.dart';

class Homework with ChangeNotifier {
  static const String ID = 'id';
  static const String LESSON_ID = 'lesson_id';
  static const String NAME = 'name';
  static const String IS_DONE = 'is_done';
  static const String DATE = 'date';
  static const String TABLE_NAME = 'homework';

  int id;
  int lessonID;
  String name;
  bool isDone;
  DateTime date;

  Map<String, dynamic> toMap() {
    return {
      ID: id,
      LESSON_ID: lessonID,
      NAME: name,
      IS_DONE: isDone ? 1 : 0,
      DATE: date.toString()
    };
  }

  Homework.fromMap(Map<String, dynamic> lessonData) {
    id = lessonData[ID];
    lessonID = lessonData[LESSON_ID];
    name = lessonData[NAME];
    isDone = lessonData[IS_DONE] == 0 ? false : true;
    date = DateTime.parse(lessonData[DATE]);
  }

  Future<void> changeIsDone() async {
    bool _oldValue = this.isDone;
    this.isDone = !this.isDone;
    notifyListeners();

    sqflite.Database database = await DatabaseHelper().database;

    try {
      database.update(
        TABLE_NAME,
        {
          IS_DONE: this.isDone ? 1 : 0,
        },
        where: '$ID = ?',
        whereArgs: [this.id]
      );
    } catch (error) {
      this.isDone = _oldValue;
      notifyListeners();
    }
  }

  Homework({
    this.id,
    @required this.lessonID,
    @required this.name,
    this.isDone = false,
    @required this.date
  });
}