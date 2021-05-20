import 'package:flutter/material.dart';
import 'package:koino/screens/nav/widgets/widgets.dart';

class AgendaScreen extends StatelessWidget {
  static const String routeName = '/agenda';

  const AgendaScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'TEAMNAME',
      ),
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
