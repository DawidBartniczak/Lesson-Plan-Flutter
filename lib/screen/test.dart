import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/testProvider.dart';
import '../model/test.dart';
import '../widget/testListTile.dart';

class TestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TestProvider testProvider = Provider.of<TestProvider>(context);
    List<Test> tests = testProvider.tests;

    return ListView(
      children: 
        tests.map((Test test) => 
          ChangeNotifierProvider.value(
            value: test,
            child: TestListTile(),
          )
        ).toList(),
    );
  }
}