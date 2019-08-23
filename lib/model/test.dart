import 'package:flutter/foundation.dart';

class Test {
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

  Test({
    this.id,
    @required this.lessonID,
    @required this.name,
    @required this.date
  });
}