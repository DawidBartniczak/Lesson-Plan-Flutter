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
}