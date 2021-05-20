import 'package:flutter/material.dart';

class AgendaScreen extends StatelessWidget {
  static const String routeName = '/agenda';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => Scaffold(
                appBar: AppBar(
                  title: Text('Termin Details'),
                ),
              ),
            ),
          ),
          child: Text('Agenda'),
        ),
      ),
    );
  }
}
