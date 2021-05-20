import 'package:flutter/material.dart';
import 'package:koino/repositories/auth/auth_repository.dart';
import 'package:koino/screens/nav/widgets/widgets.dart';

class ProfileScreen extends StatelessWidget {
  static const String routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'PROFILE',
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
