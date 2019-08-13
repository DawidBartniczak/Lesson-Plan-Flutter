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
  String date;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'lessonID': lessonID,
      'name': name,
      'date': date
    };
  }

  Test.fromMap(Map<String, dynamic> lessonData) {
    id = lessonData['id'];
    lessonID = lessonData['lessonID'];
    name = lessonData['name'];
    date = lessonData['date'];
  }

  Test({
    @required this.id,
    @required this.lessonID,
    @required this.name,
    @required this.date
  });
}