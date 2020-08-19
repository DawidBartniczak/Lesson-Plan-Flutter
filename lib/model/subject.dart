import 'package:flutter/foundation.dart';

class Subject {
  static const String ID = 'id';
  static const String SUBJECT = 'subject';
  static const String TABLE_NAME = 'subjects';

  int id;
  String subject;

  Map<String, dynamic> toMap() {
    return {
      ID: id,
      SUBJECT: subject,
    };
  }

  Subject.fromMap(Map<String, dynamic> subjectData) {
    id = subjectData[ID];
    subject = subjectData[SUBJECT];
  }

  Subject({
    this.id,
    @required this.subject,
  });
}