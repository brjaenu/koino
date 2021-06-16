import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koino/blocs/blocs.dart';
import 'package:koino/models/models.dart';
import 'package:koino/repositories/group/group_repository.dart';
import 'package:koino/screens/groups/cubit/join_group_cubit.dart';
import 'package:koino/screens/groups/widgets/join_group_sheet.dart';
import 'package:koino/screens/nav/cubit/bottom_nav_bar_cubit.dart';
import 'package:koino/screens/nav/widgets/widgets.dart';
import 'package:koino/screens/screens.dart';

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
    Map<IconData, Function> icons = {
      Icons.add: _navigateCreateGroupPage,
      Icons.vpn_key_rounded: _showActivationSheet,
    };
    return WillPopScope(
      onWillPop: () async => _popGroupsRoute(context),
      child: Scaffold(
        appBar: AppBar(
          title: Center(child: Text('GRUPPEN AUSWAHL')),
        ),
        body: _buildGroupList(groups, context),
        floatingActionButton: CustomFABGroup(icons: icons),
      ),
    );
  }

  Widget _buildGroupList(List<Group> groups, BuildContext context) {
    if (groups == null || groups.isEmpty) {
      return Center(child: Text('No groups added yet.'));
    }

    return ListView.separated(
      itemBuilder: (ctx, i) {
        return ListTile(
          title: Text(groups[i].name),
          trailing: Icon(Icons.keyboard_arrow_right_outlined),
          onTap: () {
            context
                .read<UserBloc>()
                .add(UserUpdateActiveGroup(group: groups[i]));
            _popGroupsRoute(context);
          },
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

  void _showActivationSheet(BuildContext context) {
    var _formKey = GlobalKey<FormState>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (builder) {
        return BlocProvider<JoinGroupCubit>(
          create: (_) => JoinGroupCubit(
            groupRepository: context.read<GroupRepository>(),
          ),
          child: JoinGroupSheet(
            formKey: _formKey,
          ),
        );
      },
    );
  }

  void _navigateCreateGroupPage(BuildContext context) {
    Navigator.of(context).pushNamed(CreateGroupScreen.routeName);
  }

  Future<bool> _popGroupsRoute(BuildContext context) async {
    context.read<BottomNavBarCubit>().updateNavBarVisibility(isVisible: true);
    Navigator.of(context).pop();
    return Future.value(true);
  }
}
