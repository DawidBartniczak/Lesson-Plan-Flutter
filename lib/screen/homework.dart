import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/databaseHelper.dart';
import '../model/homework.dart';

class HomeworkScreen extends StatefulWidget {
  @override
  _HomeworkScreenState createState() => _HomeworkScreenState();
}

class _HomeworkScreenState extends State<HomeworkScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  Future<List<Homework>> _homework;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  void loadData() {
    setState(() {
      _homework = _databaseHelper.homework;
    });
  }

  Widget _buildTistTile(Homework homework) {
    return Card(
      child: ListTile(
        title: Text(homework.name),
        subtitle: FutureBuilder(
          future: _databaseHelper.getLessonSubject(homework.lessonID),
          builder: (_, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData)
              return Text(snapshot.data);
            else
              return Container();
          },
        ),
        leading: CircleAvatar(
          radius: 24,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(DateFormat('dd.MM').format(homework.date)),
            ),
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.check),
          color: !homework.isDone ? Colors.grey : Colors.green,
          onPressed: () {
            _databaseHelper.changeHomeworkState(!homework.isDone, homework.id)
              .then((_) => setState(() => loadData()));
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _homework,
      builder: (_, AsyncSnapshot<List<Homework>> snapshot) {
        if (snapshot.hasData) {
          List<Homework> homework = snapshot.data;

          return ListView(
            children: 
              homework.map((Homework homework) => _buildTistTile(homework)).toList(),
          );
        } else {
          return const Center(
            child: const CircularProgressIndicator(),
          );
        }
      },
    );
  }
}