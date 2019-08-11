import 'package:flutter/material.dart';

class AnimatedProgressIndicator extends StatelessWidget {
  final bool _isLoading;
  final double _fullWidth;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: !_isLoading ? 0 : _fullWidth,
      height: 4,
      duration: const Duration(milliseconds: 200),
      reverseDuration: const Duration(milliseconds: 200),
      curve: Curves.easeIn,
      child: Visibility(
        visible: _isLoading,
        child: LinearProgressIndicator(
          backgroundColor: Colors.deepOrangeAccent[100],
        ),
      ),
    );
  }

  AnimatedProgressIndicator(this._isLoading, this._fullWidth);
}
