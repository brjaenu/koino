import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koino/blocs/blocs.dart';
import 'package:koino/screens/nav/widgets/widgets.dart';

class GroupScreen extends StatelessWidget {
  static const String routeName = '/group';

  @override
  Widget build(BuildContext context) {
    final groups = context.read<GroupBloc>().state.userGroups;
    return Scaffold(
      appBar: CustomAppBar(
        title: 'MEINE GRUPPE',
      ),
      body: Text('Groups'),
      /*StreamBuilder(
        stream: groups,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Text(
                    snapshot.data[index]["name"],
                  ),
                  title: Text('Amount'),
                );
              },
            );
          }
          return LinearProgressIndicator();
        },
      ),*/
    );
  }
}
