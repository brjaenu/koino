import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koino/blocs/blocs.dart';
import 'package:koino/blocs/user/user_bloc.dart';
import 'package:koino/models/event_model.dart';
import 'package:koino/models/models.dart';
import 'package:koino/repositories/repositories.dart';
import 'package:koino/screens/agenda/cubit/register_event_cubit.dart';
import 'package:koino/screens/create_event/create_event_screen.dart';
import 'package:koino/screens/event_detail/cubit/event_detail_cubit.dart';
import 'package:koino/screens/event_detail/event_detail_screen.dart';
import 'package:koino/screens/nav/cubit/bottom_nav_bar_cubit.dart';
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
    final isUserAdmin =
        activeGroup.ownerId == context.read<UserBloc>().state.user.id;
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
            title: "AGENDA",
          ),
          body: _buildBody(state),
          floatingActionButton: isUserAdmin
              ? FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: () => _navigateCreateEventScreen(context),
                )
              : Container(),
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
                    var card;
                    if (index == 0) {
                      card = UpcomingEventCard(event: event);
                    } else {
                      card = EventCard(event: event);
                    }

                    return BlocProvider<RegisterEventCubit>(
                      create: (context) => RegisterEventCubit(
                        eventRepository: context.read<EventRepository>(),
                      ),
                      child: GestureDetector(
                        onTap: () => openDetailPage(event),
                        child: card,
                      ),
                    );
                  })
              : Stack(
                  children: <Widget>[
                    Center(child: Text('Deine Gruppe hat im Moment keine Events.')),
                    ListView()
                  ],
                ),
        );
    }
  }

  void openDetailPage(Event event) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context) => EventDetailCubit(
              eventRepository: context.read<EventRepository>(),
              registrationRepository: context.read<RegistrationRepository>()),
          child: EventDetailScreen(
            event: event,
          ),
        ),
      ),
    );
  }

  void _navigateCreateEventScreen(BuildContext context) {
    context.read<BottomNavBarCubit>().updateNavBarVisibility(isVisible: false);
    Navigator.of(context).pushNamed(CreateEventScreen.routeName);
  }
}
