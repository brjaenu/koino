import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koino/blocs/prayers/prayer_bloc.dart';

import 'package:koino/blocs/user/user_bloc.dart';
import 'package:koino/screens/nav/widgets/widgets.dart';
import 'package:koino/screens/prayerwall/widgets/prayer_card.dart';
import 'package:koino/widgets/error_dialog.dart';

class PrayerwallScreen extends StatefulWidget {
  static const String routeName = '/prayerwall';

  const PrayerwallScreen({Key key}) : super(key: key);

  @override
  _PrayerwallScreenState createState() => _PrayerwallScreenState();
}

class _PrayerwallScreenState extends State<PrayerwallScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PrayerBloc, PrayerState>(listener: (context, state) {
      if (state.status == PrayerStatus.error) {
        showDialog(
          context: context,
          builder: (context) => ErrorDialog(content: state.failure.message),
        );
      }
    }, builder: (context, state) {
      return Scaffold(
          appBar: CustomAppBar(
            title: 'PRAYERWALL',
          ),
          body: _buildBody(state, context));
    });
  }

  Widget _buildBody(PrayerState state, BuildContext context) {
    switch (state.status) {
      case PrayerStatus.loading:
        return const Center(child: CircularProgressIndicator());
      default:
        return RefreshIndicator(
          onRefresh: () async {
            context.read<PrayerBloc>()..add(EventFetchPrayers());
            setState(() {});
          },
          child: state.prayers.length > 0
              ? ListView.builder(
                  itemCount: state.prayers.length,
                  itemBuilder: (BuildContext context, int index) {
                    final prayer = state.prayers[index];
                    return PrayerCard(prayer: prayer);
                  })
              : Stack(
                  children: <Widget>[
                    Center(
                        child: Text(
                            'Deine Gruppe hat im Moment keine Gebetsanliegen.')),
                    ListView()
                  ],
                ),
        );
    }
  }
}
