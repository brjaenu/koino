import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:koino/screens/nav/cubit/bottom_nav_bar_cubit.dart';
import 'package:koino/screens/screens.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        onPressed: () {
          context
              .read<BottomNavBarCubit>()
              .updateNavBarVisibility(isVisible: false);
          Navigator.of(context).pushNamed(GroupsScreen.routeName);
        },
        icon: FaIcon(
          FontAwesomeIcons.bars,
          color: Theme.of(context).primaryColorDark,
          size: 24.0,
        ),
        splashColor: Colors.transparent,
      ),
      title: Text(title),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed(ProfileScreen.routeName);
          },
          icon: FaIcon(
            FontAwesomeIcons.solidUserCircle,
            color: Theme.of(context).primaryColorDark,
            size: 24.0,
          ),
          splashColor: Colors.transparent,
        ),
      ],
    );
  }
}
