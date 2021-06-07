import 'package:flutter/material.dart';
import 'package:koino/blocs/blocs.dart';
import 'package:koino/models/models.dart';
import 'package:koino/screens/nav/widgets/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageGroupScreen extends StatelessWidget {
  static const String routeName = '/manage-group';

  @override
  Widget build(BuildContext context) {
    final User user = context.read<UserBloc>().state.user;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'MEINE GRUPPE',
      ),
      body: Center(
        child: Text('Group: ' + user.activeGroup?.name),
      ),
    );
  }
}
