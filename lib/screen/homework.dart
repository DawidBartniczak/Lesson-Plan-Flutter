import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/homeworkProvider.dart';
import '../model/homework.dart';
import '../widget/testListTile.dart';

class HomeworkScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    HomeworkProvider homeworkProvider = Provider.of<HomeworkProvider>(context);
    List<Homework> homework = homeworkProvider.homework;

    return homework.length > 0
      ? ListView(
        children: 
          homework.map((Homework homework) => 
            ChangeNotifierProvider.value(
              value: homework,
              child: TestListTile(),
            )
          ).toList(),
      )
      : Center(
        child: Text('Brak zadań domowych.'),
      );
  }
}