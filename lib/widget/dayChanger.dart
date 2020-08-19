import 'package:flutter/material.dart';

import '../helper/localizationHelper.dart';

class DayChanger extends StatelessWidget {
  final Function _decreaseDay;
  final Function _increaseDay;
  final int _day;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.keyboard_arrow_left),
            color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
            onPressed: _decreaseDay,
          ),
          Text(LocalizationHelper.of(context).localize('day_$_day')),
          IconButton(
            icon: Icon(Icons.keyboard_arrow_right),
            color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
            onPressed: _increaseDay,
          ),
        ],
      ),
    );
  }

  DayChanger(this._decreaseDay, this._increaseDay, this._day);
}