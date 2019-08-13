import 'package:flutter/foundation.dart';

class Lesson {
  static const String ID = 'id';
  static const String NAME = 'name';
  static const String CLASSROOM = 'classroom';
  static const String START_SECONDS = 'start_seconds';
  static const String END_SECONDS = 'end_seconds';
  static const String DAY = 'day';
  static const String TABLE_NAME = 'lessons';

  int id;
  String name;
  String classroom;
  int startSeconds;
  int endSeconds;
  int day;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'classroom': classroom,
      'startSeconds': startSeconds,
      'endSeconds': endSeconds,
      'day': day
    };
  }

  Lesson.fromMap(Map<String, dynamic> lessonData) {
    id = lessonData['id'];
    name = lessonData['name'];
    classroom = lessonData['classroom'];
    startSeconds = lessonData['startSeconds'];
    endSeconds = lessonData['endSeconds'];
    day = lessonData['day'];
  }

  Lesson({
    @required this.id,
    @required this.name,
    @required this.classroom,
    @required this.startSeconds,
    @required this.endSeconds,
    @required this.day
  });
}