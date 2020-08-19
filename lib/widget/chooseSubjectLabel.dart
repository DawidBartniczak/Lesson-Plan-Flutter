import 'package:flutter/material.dart';

import '../helper/localizationHelper.dart';

class ChooseSubjectLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(16.0, 12.0, 0.0, 12.0),
        child: Text(
          LocalizationHelper.of(context).localize('text_select_subject'),
          style: Theme.of(context).textTheme.subtitle2.copyWith(
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}