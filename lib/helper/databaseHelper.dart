import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/lesson.dart';
import '../model/homework.dart';
import '../model/test.dart';
import '../model/subject.dart';

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
    print('Database Path: $databasePath');
    _database = await openDatabase(
      databasePath,
      version: 2,
      onConfigure: _configureDatabase,
      onCreate: (Database database, int version) async {
        Batch batch = database.batch();
        switch(version) {
          case 1:
            _createTablesV1(batch);
            break;
          case 2:
            _createTablesV2(batch);
            break;
          default:
            _createTablesV2(batch);
            break;
        }
        await batch.commit();
      },
      onUpgrade: (Database database, int oldVersion, int newVersion) async {
        if (oldVersion == 1 && newVersion == 2) {
          await _migrateToV2(database);
        }
      },
    );
  }

  void _configureDatabase(Database database) async {
    await database.execute('PRAGMA foreign_keys = ON');
  }

  void _createTablesV1(Batch batch) {
    batch.execute(
      'CREATE TABLE ${Lesson.TABLE_NAME} (${Lesson.ID} INTEGER PRIMARY KEY, ${Lesson.SUBJECT} TEXT NOT NULL, ${Lesson.CLASSROOM} TEXT NOT NULL, ${Lesson.START_HOUR} INTEGER NOT NULL, ${Lesson.START_MINUTE} INTEGER NOT NULL, ${Lesson.END_HOUR} INTEGER NOT NULL, ${Lesson.END_MINUTE} INTEGER NOT NULL, ${Lesson.DAY} INTEGER NOT NULL)',
    );
    batch.execute(
      'CREATE TABLE ${Homework.TABLE_NAME} (${Homework.ID} INTEGER PRIMARY KEY, ${Homework.LESSON_ID} INTEGER NOT NULL REFERENCES ${Lesson.TABLE_NAME}(${Lesson.ID}), ${Homework.NAME} TEXT NOT NULL, ${Homework.IS_DONE} INTEGER DEFAULT 0, ${Homework.DATE} TEXT NOT NULL)',
    );
    batch.execute(
      'CREATE TABLE ${Test.TABLE_NAME} (${Test.ID} INTEGER PRIMARY KEY, ${Test.LESSON_ID} INTEGER NOT NULL REFERENCES ${Lesson.TABLE_NAME}(${Lesson.ID}), ${Test.NAME} TEXT NOT NULL, ${Test.DATE} TEXT NOT NULL)',
    );
  }

  void _createTablesV2(Batch batch) {
    batch.execute(
      'CREATE TABLE ${Subject.TABLE_NAME} (${Subject.ID} INTEGER PRIMARY KEY, ${Subject.SUBJECT} TEXT NOT NULL)'
    );
    batch.execute(
      'CREATE TABLE ${Lesson.TABLE_NAME} (${Lesson.ID} INTEGER PRIMARY KEY, ${Lesson.SUBJECT} TEXT NOT NULL, ${Lesson.SUBJECT_ID} INT NOT NULL REFERENCES ${Subject.TABLE_NAME}(${Subject.ID}), ${Lesson.CLASSROOM} TEXT NOT NULL, ${Lesson.START_HOUR} INTEGER NOT NULL, ${Lesson.START_MINUTE} INTEGER NOT NULL, ${Lesson.END_HOUR} INTEGER NOT NULL, ${Lesson.END_MINUTE} INTEGER NOT NULL, ${Lesson.DAY} INTEGER NOT NULL)',
    );
    batch.execute(
      'CREATE TABLE ${Homework.TABLE_NAME} (${Homework.ID} INTEGER PRIMARY KEY, ${Homework.LESSON_ID} INTEGER NOT NULL REFERENCES ${Lesson.TABLE_NAME}(${Lesson.ID}), ${Homework.NAME} TEXT NOT NULL, ${Homework.IS_DONE} INTEGER DEFAULT 0, ${Homework.DATE} TEXT NOT NULL)',
    );
    batch.execute(
      'CREATE TABLE ${Test.TABLE_NAME} (${Test.ID} INTEGER PRIMARY KEY, ${Test.LESSON_ID} INTEGER NOT NULL REFERENCES ${Lesson.TABLE_NAME}(${Lesson.ID}), ${Test.NAME} TEXT NOT NULL, ${Test.DATE} TEXT NOT NULL)',
    );
  }

  Future<void> _migrateToV2(Database database) async {
    Batch batchStructureUpdate = database.batch();
    batchStructureUpdate.execute(
      'CREATE TABLE ${Subject.TABLE_NAME} (${Subject.ID} INTEGER PRIMARY KEY, ${Subject.SUBJECT} TEXT NOT NULL)'
    );
    batchStructureUpdate.execute(
      'ALTER TABLE ${Lesson.TABLE_NAME} ADD ${Lesson.SUBJECT_ID} INTEGER REFERENCES ${Subject.TABLE_NAME}(${Subject.ID})'
    );
    await batchStructureUpdate.commit();

    List<Map<String, dynamic>> lessonsData = await database.query(
      Lesson.TABLE_NAME,
      columns: [Lesson.ID, Lesson.SUBJECT]
    );
    List<Lesson> lessons = lessonsData.map((Map rawLesson) => Lesson.fromMap(rawLesson)).toList();
    
    Map<String, List<int>> subjects = Map();
    Map<String, int> subjectIds = Map();

    lessons.forEach((Lesson lesson) {
      subjects.putIfAbsent(lesson.subject, () => List());
      subjects[lesson.subject].add(lesson.id);
    });

    for (String subject in subjects.keys) {
      int id = await database.insert(Subject.TABLE_NAME, {
        Subject.ID: null,
        Subject.SUBJECT: subject,
      });
      subjectIds[subject] = id;
    }

    Batch batch = database.batch();
    subjects.forEach((String subject, List<int> ids) {
      ids.forEach((int id) {
        batch.update(Lesson.TABLE_NAME, {
          Lesson.SUBJECT_ID: subjectIds[subject]
        }, where: 'id = ?', whereArgs: [id]);
      });
    });
    await batch.commit();
  }
}
