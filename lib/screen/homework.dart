import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../provider/homeworkProvider.dart';
import '../provider/lessonProvider.dart';
import '../model/homework.dart';

class HomeworkScreen extends StatefulWidget {
  @override
  _HomeworkScreenState createState() => _HomeworkScreenState();
}

class _HomeworkScreenState extends State<HomeworkScreen> {

  Widget _buildTistTile(Homework homework, LessonProvider lessonProvider) {
    return Card(
      child: ListTile(
        title: Text(homework.name),
        subtitle: Text(lessonProvider.lessonSubjectForId(homework.lessonID)),
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
            
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    HomeworkProvider homeworkProvider = Provider.of<HomeworkProvider>(context);
    LessonProvider lessonProvider = Provider.of<LessonProvider>(context, listen: false);
    List<Homework> homework = homeworkProvider.homework;


    return ListView(
      children: 
        homework.map((Homework homework) => _buildTistTile(homework, lessonProvider)).toList(),
    );
  }
}