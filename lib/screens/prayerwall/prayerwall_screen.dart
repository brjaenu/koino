import 'package:flutter/material.dart';
import 'package:koino/screens/nav/widgets/widgets.dart';

class PrayerwallScreen extends StatelessWidget {
  static const String routeName = '/prayerwall';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'PRAYERWALL',
      ),
      body: Center(
        child: Text('Prayerwall'),
      ),
    );
  }
}
