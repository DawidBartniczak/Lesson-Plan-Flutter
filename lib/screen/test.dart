import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/databaseHelper.dart';
import '../model/test.dart';

class TestScreen extends StatelessWidget {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _databaseHelper.tests,
      builder: (_, AsyncSnapshot<List<Test>> snapshot) {
        if (snapshot.hasData) {
          List<Test> tests = snapshot.data;

          return ListView(
            children: tests.map((Test test) {
              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                child: ListTile(
                  title: Text(test.name),
                  subtitle: FutureBuilder(
                    future: _databaseHelper.getLessonSubject(test.lessonID),
                    builder: (_, AsyncSnapshot<String> snapshot) {
                      if (snapshot.hasData) {
                        return Text(snapshot.data);
                      } else {
                        return  Container();
                      }
                    },
                  ),
                  leading: CircleAvatar(
                    radius: 24,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(DateFormat('dd.MM').format(test.date)),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}