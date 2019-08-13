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
    _database = await openDatabase(databasePath, version: 1,
      onCreate: _createTables
    );
  }

  void _createTables(Database database, _) async {
    await database.execute(
      'CREATE TABLE ${Lesson.TABLE_NAME} (${Lesson.ID} INTEGER PRIMARY KEY, ${Lesson.NAME} TEXT, ${Lesson.CLASSROOM} TEXT, ${Lesson.START_SECONDS} INTEGER, ${Lesson.END_SECONDS} INTEGER, ${Lesson.DAY} INTEGER)',
    );
    await database.execute(
      'CREATE TABLE ${Homework.TABLE_NAME} (${Homework.ID} INTEGER PRIMARY KEY, ${Homework.LESSON_ID} INTEGER, ${Homework.NAME} TEXT, ${Homework.DATE} TEXT)',
    );
    await database.execute(
      'CREATE TABLE ${Test.TABLE_NAME} (${Test.ID} INTEGER PRIMARY KEY, ${Test.LESSON_ID} INTEGER, ${Test.NAME} TEXT, ${Test.DATE} TEXT)',
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
    columns: [Lesson.ID, Lesson.NAME, Lesson.CLASSROOM, Lesson.START_SECONDS, Lesson.END_SECONDS, Lesson.DAY]);
    return lessonsData.map((Map lessonData) => Lesson.fromMap(lessonData)).toList();
  }

  Future<List<Homework>> get homework async {
    List<Map<String, dynamic>> homeworkData = await (await database).query(Homework.TABLE_NAME);
    return homeworkData.map((Map homeworkMap) => Homework.fromMap(homeworkMap)).toList();
  }

  Future<List<Test>> get tests async {
    List<Map<String, dynamic>> testsData = await (await database).query(Test.TABLE_NAME);
    return testsData.map((Map testData) => Test.fromMap(testData)).toList();
  }
}
