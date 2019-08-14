import 'package:flutter/foundation.dart';

class Lesson {
  static const String ID = 'id';
  static const String SUBJECT = 'subject';
  static const String CLASSROOM = 'classroom';
  static const String START_HOUR = 'start_hour';
  static const String START_MINUTE = 'start_minute';
  static const String END_HOUR = 'end_hour';
  static const String END_MINUTE = 'end_minute';
  static const String DAY = 'day';
  static const String TABLE_NAME = 'lessons';

  int id;
  String subject;
  String classroom;
  int startHour;
  int startMinute;
  int endHour;
  int endMinute;
  int day;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subject': subject,
      'classroom': classroom,
      'start_hour': startHour,
      'start_minute': startMinute,
      'end_hour': endHour,
      'end_minute': endMinute,
      'day': day
    };
  }

  Lesson.fromMap(Map<String, dynamic> lessonData) {
    id = lessonData['id'];
    subject = lessonData['subject'];
    classroom = lessonData['classroom'];
    startHour = lessonData['start_hour'];
    startMinute = lessonData['start_minute'];
    endHour = lessonData['end_hour'];
    endMinute = lessonData['end_minute'];
    day = lessonData['day'];
  }

  Lesson({
    @required this.id,
    @required this.subject,
    @required this.classroom,
    @required this.startHour,
    @required this.startMinute,
    @required this.endHour,
    @required this.endMinute,
    @required this.day
  });
}