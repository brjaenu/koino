import 'package:flutter/material.dart';
import 'package:koino/screens/nav/widgets/widgets.dart';

class GroupScreen extends StatelessWidget {
  static const String routeName = '/group';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'MEINE GRUPPE',
      ),
      body: Center(
        child: Text('Group'),
      ),
    );
  }
}
