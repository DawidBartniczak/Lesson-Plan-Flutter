import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../helper/databaseHelper.dart';

class Test with ChangeNotifier {
  static const String ID = 'id';
  static const String LESSON_ID = 'lesson_id';
  static const String NAME = 'name';
  static const String DATE = 'date';
  static const String TABLE_NAME = 'tests';

  int id;
  int lessonID;
  String name;
  DateTime date;

  Map<String, dynamic> toMap() {
    return {
      ID: id,
      LESSON_ID: lessonID,
      NAME: name,
      DATE: date.toString()
    };
  }

  Test.fromMap(Map<String, dynamic> lessonData) {
    id = lessonData[ID];
    lessonID = lessonData[LESSON_ID];
    name = lessonData[NAME];
    date = DateTime.parse(lessonData[DATE]);
  }

  Future<void> changeName(String newName) async {
    String _oldValue = this.name;
    this.name = newName;
    notifyListeners();

    sqflite.Database database = await DatabaseHelper().database;

    try {
      database.update(
        TABLE_NAME,
        {
          NAME: this.name,
        },
        where: '$ID = ?',
        whereArgs: [this.id]
      );
    } catch (error) {
      this.name = _oldValue;
      notifyListeners();
    }
  }

  Test({
    this.id,
    @required this.lessonID,
    @required this.name,
    @required this.date
  });
}