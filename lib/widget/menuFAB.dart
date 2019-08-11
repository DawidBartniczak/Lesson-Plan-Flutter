import 'package:flutter/material.dart';

class FloatingActionButtonMenuItem {
  final int id;
  final String tooltipText;
  final IconData itemIcon;

  FloatingActionButtonMenuItem({
    @required this.id,
    @required this.tooltipText,
    @required this.itemIcon,
  });
}

class FloatingActionButtonMenu extends StatefulWidget {
  final Function(int) _onItemSelected;
  final List<FloatingActionButtonMenuItem> _menuItems;

  FloatingActionButtonMenu(this._onItemSelected, this._menuItems);

  @override
  _FloatingActionButtonMenuState createState() => _FloatingActionButtonMenuState();
}

class _FloatingActionButtonMenuState extends State<FloatingActionButtonMenu> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<Color> _colorAnimation;
  Animation<double> _iconAnimation;
  Animation<double> _itemScaleAnimation;
  Animation<double> _itemAnimation;
  Curve _animationCurve = Curves.easeOut;
  double floatingActionButtonHeight = 56.0;
  bool _isOpen = false;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400)
    )..addListener(() => setState(() {}));
    _iconAnimation = Tween<double>(begin: 0.0, end: 1.0)
      .animate(_animationController);
    _colorAnimation = ColorTween(begin: Colors.deepOrangeAccent, end: Colors.red)
      .animate(_animationController);
    _itemScaleAnimation = Tween<double>(begin: 0.2, end: 1.0)
      .animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.75, curve: _animationCurve)
      ));
    _itemAnimation = Tween<double>(begin: floatingActionButtonHeight, end: -12.0)
      .animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.75, curve: _animationCurve)
      ));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void animate() {
    if (!_isOpen)
      _animationController.forward();
    else
      _animationController.reverse();
    
    _isOpen = !_isOpen;
  }

  Widget menuFloatingActionButton() {
    return FloatingActionButton(
      backgroundColor: _colorAnimation.value,
      tooltip: 'Menu',
      child: AnimatedIcon(
        icon: AnimatedIcons.menu_close,
        progress: _iconAnimation,
      ),
      onPressed: animate,
    );
  }

  Widget buildMenuFloatingActionButton(FloatingActionButtonMenuItem menuItem) {
    final double yOffset = _itemAnimation.value * menuItem.id;

    return Transform(
      transform: Matrix4.translationValues(0.0, yOffset, 0.0),
      child: Container(
          child: FloatingActionButton(
            heroTag: menuItem.id,
            elevation: 0,
            onPressed: () {
              widget._onItemSelected(menuItem.id);
              animate();
            },
            tooltip: menuItem.tooltipText,
            child: Icon(menuItem.itemIcon),
          ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        ...widget._menuItems.reversed.map(buildMenuFloatingActionButton).toList(),
        menuFloatingActionButton()
      ],
    );
  }
}