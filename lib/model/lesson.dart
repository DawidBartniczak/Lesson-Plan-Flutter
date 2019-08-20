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
      ID: id,
      SUBJECT: subject,
      CLASSROOM: classroom,
      START_HOUR: startHour,
      START_MINUTE: startMinute,
      END_HOUR: endHour,
      END_MINUTE: endMinute,
      DAY: day
    };
  }

  Lesson.fromMap(Map<String, dynamic> lessonData) {
    id = lessonData[ID];
    subject = lessonData[SUBJECT];
    classroom = lessonData[CLASSROOM];
    startHour = lessonData[START_HOUR];
    startMinute = lessonData[START_MINUTE];
    endHour = lessonData[END_HOUR];
    endMinute = lessonData[END_MINUTE];
    day = lessonData[DAY];
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