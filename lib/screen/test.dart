import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/testProvider.dart';
import '../model/test.dart';
import '../widget/testListTile.dart';

class TestScreen extends StatelessWidget {
  TestProvider _testProvider;

  @override
  Widget build(BuildContext context) {
    _testProvider = Provider.of<TestProvider>(context);
    List<Test> tests = _testProvider.tests;

    return ListView(
      children: tests.map((Test test) => TestListTile(test)).toList(),
    );
  }
}