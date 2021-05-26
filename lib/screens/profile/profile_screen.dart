import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koino/repositories/auth/auth_repository.dart';
import 'package:koino/screens/nav/widgets/widgets.dart';
import 'package:koino/screens/profile/bloc/profile_bloc.dart';

class ProfileScreen extends StatelessWidget {
  static const String routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    final user = context.read<ProfileBloc>().state.user;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'PROFILE',
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(user.username),
          Center(
            child: Text('Profile'),
          ),
          ElevatedButton(
            onPressed: () => AuthRepository().logOut(),
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}
