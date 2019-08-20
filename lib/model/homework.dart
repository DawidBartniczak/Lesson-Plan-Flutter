import 'package:flutter/foundation.dart';

class Homework {
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
  String date;

  Map<String, dynamic> toMap() {
    return {
      ID: id,
      LESSON_ID: lessonID,
      NAME: name,
      IS_DONE: isDone ? 1 : 0,
      DATE: date
    };
  }

  Homework.fromMap(Map<String, dynamic> lessonData) {
    id = lessonData[ID];
    lessonID = lessonData[LESSON_ID];
    name = lessonData[NAME];
    isDone = lessonData[IS_DONE] != 0 ? true : false;
    date = lessonData[DATE];
  }

  Homework({
    this.id,
    @required this.lessonID,
    @required this.name,
    this.isDone = false,
    @required this.date
  });
}