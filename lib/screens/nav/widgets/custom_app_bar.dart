import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;
  final String title;

  const CustomAppBar({
    Key key,
    @required this.title,
  })  : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () => print('Klicked explorer'),
        icon: Icon(Icons.explore_rounded),
        splashColor: Colors.transparent,
      ),
      title: Text(title),
    );
  }
}
