import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../helper/databaseHelper.dart';
import '../model/test.dart';

class TestProvider with ChangeNotifier {
  List<Test> _tests = [];

  List<Test> get tests => _tests;

  Future<void> fetchTests() async {
    sqflite.Database database = await DatabaseHelper().database;

    List<Map<String, dynamic>> testsData = await database.query(Test.TABLE_NAME);
    _tests = testsData
      .map((Map rawTest) => Test.fromMap(rawTest))
      .where((Test test) => test.date.isAfter(DateTime.now()))
      .toList();
    
    notifyListeners();
  }

  Future<void> addTest(Test test) async {
    sqflite.Database database = await DatabaseHelper().database;

    test.id = await database.insert(Test.TABLE_NAME, test.toMap());
    _tests.add(test);

    notifyListeners();
  }

  Future<void> deleteTest(int id) async {
    Test _oldTest = _tests.firstWhere((Test test) => test.id == id);
    _tests.remove(_oldTest);
    notifyListeners();

    sqflite.Database database = await DatabaseHelper().database;

    try {
      await database.delete(Test.TABLE_NAME, where: '${Test.ID} = ?', whereArgs: [id]);
    } catch (error) {
      _tests.add(_oldTest);
      notifyListeners();
    }
  }

  void deleteTestsForLesson(int lessonId) {
    _tests.removeWhere((Test test) => test.lessonID == lessonId);

    notifyListeners();
  }
}