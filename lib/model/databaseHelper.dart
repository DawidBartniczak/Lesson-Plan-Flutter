import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import './lesson.dart';
import './homework.dart';
import './test.dart';

class DatabaseHelper {
  static const DATABASE_NAME = 'lesson_plan.db';
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    await _initDatabase();
    return _database;
  }

  Future _initDatabase() async {
    String databasePath = join(await getDatabasesPath(), DATABASE_NAME);
    print(databasePath);
    _database = await openDatabase(databasePath, version: 1,
      onCreate: _createTables
    );
  }

  void _createTables(Database database, _) async {
    await database.execute(
      'CREATE TABLE ${Lesson.TABLE_NAME} (${Lesson.ID} INTEGER PRIMARY KEY, ${Lesson.SUBJECT} TEXT NOT NULL, ${Lesson.CLASSROOM} TEXT NOT NULL, ${Lesson.START_HOUR} INTEGER NOT NULL, ${Lesson.START_MINUTE} INTEGER NOT NULL, ${Lesson.END_HOUR} INTEGER NOT NULL, ${Lesson.END_MINUTE} INTEGER NOT NULL, ${Lesson.DAY} INTEGER NOT NULL)',
    );
    await database.execute(
      'CREATE TABLE ${Homework.TABLE_NAME} (${Homework.ID} INTEGER PRIMARY KEY, ${Homework.LESSON_ID} INTEGER NOT NULL REFERENCES ${Lesson.TABLE_NAME}(${Lesson.ID}), ${Homework.NAME} TEXT NOT NULL, ${Homework.IS_DONE} INTEGER DEFAULT 0, ${Homework.DATE} TEXT NOT NULL)',
    );
    await database.execute(
      'CREATE TABLE ${Test.TABLE_NAME} (${Test.ID} INTEGER PRIMARY KEY, ${Test.LESSON_ID} INTEGER NOT NULL REFERENCES ${Lesson.TABLE_NAME}(${Lesson.ID}), ${Test.NAME} TEXT NOT NULL, ${Test.DATE} TEXT NOT NULL)',
    );
  }

  Future<Lesson> insertLesson(Lesson lesson) async {
    lesson.id = await (await database).insert(Lesson.TABLE_NAME, lesson.toMap());
    return lesson;
  }

  Future<Homework> insertHomework(Homework homework) async {
    homework.id = await (await database).insert(Homework.TABLE_NAME, homework.toMap());
    return homework;
  }

  Future<Test> insertTest(Test test) async {
    test.id = await (await database).insert(Test.TABLE_NAME, test.toMap());
    return test;
  }

  Future<List<Lesson>> get lessons async {
    List<Map<String, dynamic>> lessonsData = await (await database).query(Lesson.TABLE_NAME,
    columns: [Lesson.ID, Lesson.SUBJECT, Lesson.CLASSROOM, Lesson.START_HOUR, Lesson.START_MINUTE, Lesson.END_HOUR, Lesson.END_MINUTE, Lesson.DAY]);
    return lessonsData.map((Map rawLesson) => Lesson.fromMap(rawLesson)).toList();
  }

  Future<List<Homework>> get homework async {
    List<Map<String, dynamic>> homeworkData = await (await database).query(Homework.TABLE_NAME);
    return homeworkData.map((Map rawHomework) => Homework.fromMap(rawHomework)).toList();
  }

  Future<List<Test>> get tests async {
    List<Map<String, dynamic>> testsData = await (await database).query(Test.TABLE_NAME);
    return testsData.map((Map rawTest) => Test.fromMap(rawTest)).toList();
  }

  Future<List<Lesson>> getLessonsForDay(int day) async {
    List<Map<String, dynamic>> lessonsData =
      await (await database).query(Lesson.TABLE_NAME, where: '${Lesson.DAY} = ?', whereArgs: [day]);
    return lessonsData.map((Map rawLesson) => Lesson.fromMap(rawLesson)).toList();
  }

  Future<String> getLessonSubject(int lessonID) async {
    List<Map<String, dynamic>> lessonsData =
      await (await database).query(
        Lesson.TABLE_NAME,
        where: 'id = ?',
        whereArgs: [lessonID]
      );
    if (lessonsData.first != null)
      return lessonsData.first[Lesson.SUBJECT];
    else
      return null;
  }

  Future<Homework> getHomeworkForLesson(int lessonID) async {
    List<Map<String, dynamic>> homeworkData =
      await (await database).query(Homework.TABLE_NAME, where: '${Homework.LESSON_ID} = ?', whereArgs: [lessonID]);
    Homework homework = homeworkData.map((Map rawHomework) => Homework.fromMap(rawHomework)).toList().first;
    if (homework.date.isAfter(DateTime.now()))
      return homework;
    else {
      await deleteHomework(homework.id);
      return null;
    }
  }
  
  Future<Test> getTestForLesson(int lessonID) async {
    List<Map<String, dynamic>> testData =
      await (await database).query(Test.TABLE_NAME, where: '${Test.LESSON_ID} = ?', whereArgs: [lessonID]);
    return testData.map((Map rawTest) => Test.fromMap(rawTest)).toList()
      .first;
  }

  Future deleteLesson(int lessonID) async {
    await (await database).delete(
      Lesson.TABLE_NAME,
      where: '${Lesson.ID} = ?',
      whereArgs: [lessonID]
    );
    await (await database).delete(
      Homework.TABLE_NAME,
      where: '${Homework.LESSON_ID} = ?',
      whereArgs: [lessonID]
    );
    await (await database).delete(
      Test.TABLE_NAME,
      where: '${Test.LESSON_ID} = ?',
      whereArgs: [lessonID]
    );
  }

  Future deleteHomework(int homeworkID) async {
    await (await database).delete(
      Homework.TABLE_NAME,
      where: 'id = ?',
      whereArgs: [homeworkID]
    );
  }

  Future changeHomeworkState(bool state, int homeworkID) async {
    await (await database).update(
      Homework.TABLE_NAME, 
      {Homework.IS_DONE: state ? 1 : 0},
      where: 'id = ?',
      whereArgs: [homeworkID]
    );
  }
}
