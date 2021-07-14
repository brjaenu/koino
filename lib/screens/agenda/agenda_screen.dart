import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koino/blocs/blocs.dart';
import 'package:koino/blocs/user/user_bloc.dart';
import 'package:koino/models/event_model.dart';
import 'package:koino/models/models.dart';
import 'package:koino/screens/event_detail/event_detail_screen.dart';
import 'package:koino/screens/nav/widgets/widgets.dart';
import 'package:koino/widgets/widgets.dart';

import 'widgets/event_card.dart';
import 'widgets/upcoming_event_card.dart';

class AgendaScreen extends StatefulWidget {
  static const String routeName = '/agenda';

  const AgendaScreen({Key key}) : super(key: key);

  @override
  _AgendaScreenState createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  @override
  Widget build(BuildContext context) {
    final activeGroup = context.read<UserBloc>().state.user.activeGroup;
    return BlocConsumer<EventBloc, EventState>(
      listener: (context, state) {
        if (state.status == EventStatus.error) {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(content: state.failure.message),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAppBar(
            title: activeGroup.name,
          ),
          body: _buildBody(state),
        );
      },
    );
  }

  Widget _buildBody(EventState state) {
    switch (state.status) {
      case EventStatus.loading:
        return const Center(child: CircularProgressIndicator());
      default:
        return RefreshIndicator(
          onRefresh: () async {
            context.read<EventBloc>()..add(EventFetchEvents());
            setState(() {});
          },
          child: state.events.length > 0
              ? ListView.builder(
                  itemCount: state.events.length,
                  itemBuilder: (BuildContext context, int index) {
                    final event = state.events[index];
                    if (index == 0) {
                      return GestureDetector(
                        onTap: () => openDetailPage(event),
                        child: UpcomingEventCard(event: event),
                      );
                    }
                    return EventCard(event: event);
                  })
              : Stack(
                  children: <Widget>[
                    Center(child: Text('No events available')),
                    ListView()
                  ],
                ),
        );
    }
  }

  void openDetailPage(Event event) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EventDetailScreen(
          event: event,
        ),
      ),
    );
  }
}
