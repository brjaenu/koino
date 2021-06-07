import 'package:flutter/material.dart';
import 'dart:math' as math;

class CustomFABGroup extends StatefulWidget {
  final Map<IconData, Function> _icons;
  const CustomFABGroup({Key key, Map<IconData, Function> icons})
      : _icons = icons,
        super(key: key);

  @override
  _CustomFABGroupState createState() => _CustomFABGroupState();
}

class _CustomFABGroupState extends State<CustomFABGroup>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var icons = widget._icons;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: new List.generate(icons.length, (int index) {
        var entry = icons.entries.elementAt(index);
        Widget child = new Container(
          height: 60.0,
          width: 100.0,
          alignment: FractionalOffset.topCenter,
          child: new ScaleTransition(
            scale: new CurvedAnimation(
              parent: _controller,
              curve: new Interval(0.0, 1.0 - index / icons.length / 2.0,
                  curve: Curves.easeOut),
            ),
            child: new FloatingActionButton(
              heroTag: null,
              mini: true,
              child: new Icon(entry.key),
              onPressed: () {
                entry.value();
                _controller.reverse();
              },
            ),
          ),
        );
        return child;
      }).toList()
        ..add(
          new FloatingActionButton(
            heroTag: null,
            child: new AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, Widget child) {
                return new Transform(
                  transform:
                      new Matrix4.rotationZ(_controller.value * 0.5 * math.pi),
                  alignment: FractionalOffset.center,
                  child: new Icon(
                      _controller.isDismissed ? Icons.add : Icons.close),
                );
              },
            ),
            onPressed: () {
              if (_controller.isDismissed) {
                _controller.forward();
              } else {
                _controller.reverse();
              }
            },
          ),
        ),
    );
  }
}
