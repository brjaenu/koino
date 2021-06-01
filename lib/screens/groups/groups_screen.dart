import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koino/blocs/blocs.dart';
import 'package:koino/models/models.dart';
import 'package:koino/screens/nav/cubit/bottom_nav_bar_cubit.dart';
import 'package:koino/screens/nav/widgets/widgets.dart';

class GroupsScreen extends StatelessWidget {
  static const String routeName = '/groups';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => GroupsScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final groups = context.read<UserBloc>().state.groups;
    const List<IconData> icons = const [Icons.add, Icons.vpn_key_rounded];
    return WillPopScope(
      onWillPop: () async => _willPopCallback(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text('GRUPPEN AUSWAHL'),
        ),
        body: _buildGroupList(groups),
        floatingActionButton: CustomFABGroup(icons: icons),
      ),
    );
  }

  Widget _buildGroupList(List<Group> groups) {
    return ListView.separated(
      itemBuilder: (ctx, i) {
        return ListTile(
          title: Text(groups[i].name),
          trailing: Icon(Icons.keyboard_arrow_right_outlined),
          onTap: () {},
        );
      },
      separatorBuilder: (ctx, i) {
        return Divider(
          thickness: 2.0,
        );
      },
      itemCount: groups.length,
    );
  }

  Future<bool> _willPopCallback(BuildContext context) async {
    context.read<BottomNavBarCubit>().updateNavBarVisibility(isVisible: true);
    Navigator.of(context).pop();
    return Future.value(true);
  }
}
