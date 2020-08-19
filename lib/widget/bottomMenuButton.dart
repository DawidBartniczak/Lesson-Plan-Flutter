import 'package:flutter/material.dart';
import 'package:lessonplan/model/bottomMenuAction.dart';

class BottomMenuButton extends StatelessWidget {
  final BuildContext context;
  final List<BottomMenuAction> actions;
  final Function(dynamic) onSelected;
  final String tooltip;
  final String closeLabel;

  void _showBottomMenu() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...actions.map((BottomMenuAction bottomMenuAction) => InkWell(
                child: ListTile(
                  title: Text(bottomMenuAction.name),
                  leading: bottomMenuAction.icon,
                ),
                onTap: () => Navigator.of(context).pop(bottomMenuAction.value),
              )).toList(),
              Divider(height: 1),
              InkWell(
                child: ListTile(
                  title: Text(closeLabel),
                  leading: Icon(Icons.close),
                  onTap: () => Navigator.of(context).pop(null),
                )
              )
            ],
          ),
        );
      }
    ).then((value) => onSelected(value));
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.more_vert),
      tooltip: tooltip,
      color: Colors.grey,
      onPressed: _showBottomMenu,
    );
  }

  BottomMenuButton({
    @required this.context,
    @required this.actions,
    @required this.onSelected,
    this.tooltip = 'More',
    this.closeLabel = 'Close'
  });
}