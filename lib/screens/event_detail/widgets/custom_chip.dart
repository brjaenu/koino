import 'package:flutter/material.dart';

class CustomChip extends StatelessWidget {
  final String label;
  final bool isHighlighted;
  const CustomChip({
    Key key,
    @required this.label,
    @required this.isHighlighted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var backgroundColor = isHighlighted ? Colors.amber : Colors.grey;
    var textColor = isHighlighted ? Colors.white : Colors.black;
    return Chip(
      label: Text(
        label,
        style: TextStyle(color: textColor),
      ),
      backgroundColor: backgroundColor,
    );
  }
}
