import 'package:flutter/material.dart';
import 'package:jugruppe/auth/authentication_service.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(child: Text("Successfully signed in")),
            ElevatedButton(onPressed: () {
              context.read<AuthenticationService>().signOut();
            }, child: Text("Sign out"))
          ],
        ),
      ),
    );
  }
}
