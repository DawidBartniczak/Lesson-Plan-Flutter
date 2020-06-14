import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../model/databaseHelper.dart';
import '../model/lesson.dart';
import '../model/homework.dart';
import '../model/test.dart';
import '../model/subject.dart';

class LessonProvider extends ChangeNotifier {
  List<Lesson> _lessons = [];
  List<Subject> _subjects = [];

  List<Lesson> get lessons => _lessons;
  List<Subject> get subjects => _subjects;

  Future<void> fetchLessons() async {
    sqflite.Database database = await DatabaseHelper().database;

    List<Map<String, dynamic>> lessonsData = await database.query(Lesson.TABLE_NAME);
    _lessons = lessonsData.map((Map rawLesson) => Lesson.fromMap(rawLesson)).toList();

    List<Map<String, dynamic>> subjectsData = await database.query(Subject.TABLE_NAME);
    _subjects = subjectsData.map((Map rawSubject) => Subject.fromMap(rawSubject)).toList();
    
    notifyListeners();
  }

  List<Lesson> lessonsForDay(int day) => _lessons.where((Lesson lesson) => lesson.day == day).toList();

  Future<void> addLesson(Lesson lesson) async {
    sqflite.Database database = await DatabaseHelper().database;
    Subject subject;
    try {
      subject = _subjects.firstWhere((Subject subject) => subject.subject == lesson.subject);
    } catch (_) {
      subject = null;
    }
    int subjectId;

    if (subject == null) {
      subject = Subject(
        subject: lesson.subject
      );
      subjectId = await database.insert(
        Subject.TABLE_NAME,
        subject.toMap()
      );
      subject.id = subjectId;
      _subjects.add(subject);
    } else {
      subjectId = subject.id;
    }

    lesson.subjectId = subjectId;
    lesson.id = await database.insert(Lesson.TABLE_NAME, lesson.toMap());

    _lessons.add(lesson);
    notifyListeners();
  }

  Future<void> deleteLesson(int id) async {
    Lesson _oldLesson = _lessons.firstWhere((Lesson lesson) => lesson.id == id);
    Subject _oldSubject;
    _lessons.remove(_oldLesson);
    notifyListeners();

    sqflite.Database database = await DatabaseHelper().database;

    sqflite.Batch _batchWrite = database.batch();

    int remainigLessonsSharingSubject = _lessons.where((Lesson lesson) => lesson.subjectId == _oldLesson.subjectId).length;

    _batchWrite.delete(Homework.TABLE_NAME, where: '${Homework.LESSON_ID} = ?', whereArgs: [id]);
    _batchWrite.delete(Test.TABLE_NAME, where: '${Test.LESSON_ID} = ?', whereArgs: [id]);
    _batchWrite.delete(Lesson.TABLE_NAME, where: '${Lesson.ID} = ?', whereArgs: [id]);

    if (remainigLessonsSharingSubject == 0) {
      _batchWrite.delete(Subject.TABLE_NAME, where: '${Subject.ID} = ?', whereArgs: [_oldLesson.subjectId]);
      try {
        _oldSubject = _subjects.firstWhere((Subject subject) => subject.id == _oldLesson.subjectId);
        _subjects.remove(_oldSubject);
      } catch (_) {
        _oldSubject = null;
      }
    }

    try {
      await _batchWrite.commit();
    } catch (error) {
      _lessons.add(_oldLesson);
      if (_oldSubject != null)
        _subjects.add(_oldSubject);
      notifyListeners();
    }
  }
}