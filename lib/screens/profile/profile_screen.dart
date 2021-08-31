import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koino/blocs/user/user_bloc.dart';
import 'package:koino/repositories/auth/auth_repository.dart';
import 'package:koino/screens/nav/widgets/widgets.dart';

class ProfileScreen extends StatelessWidget {
  static const String routeName = '/profile';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => ProfileScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserBloc>().state.user;

    return Scaffold(
      appBar: AppBar(
        title: Text('PROFILE'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(user.email),
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
