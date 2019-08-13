import 'package:flutter/material.dart';

class AnimatedProgressIndicator extends StatelessWidget {
  final bool _isLoading;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _isLoading,
      child: LinearProgressIndicator(
        backgroundColor: Colors.deepPurpleAccent[100],
      ),
    );
  }

  AnimatedProgressIndicator(this._isLoading);
}
