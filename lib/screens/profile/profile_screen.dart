import 'package:flutter/material.dart';
import 'package:koino/repositories/auth/auth_repository.dart';

class ProfileScreen extends StatelessWidget {
  static const String routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
