import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jugruppe/auth/signin_page.dart';
import 'package:jugruppe/home_page.dart';
import 'package:provider/provider.dart';

class AuthenticationWrapper extends StatelessWidget {
  static const routeName = '/signin';

  const AuthenticationWrapper({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();

    if (firebaseUser != null) {
      return HomePage();
    }

    return SignInPage();
  }
}
