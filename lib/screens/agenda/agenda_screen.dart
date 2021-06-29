import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koino/blocs/user/user_bloc.dart';
import 'package:koino/models/event_model.dart';
import 'package:koino/models/models.dart';
import 'package:koino/screens/nav/widgets/widgets.dart';
import 'package:koino/widgets/widgets.dart';

import 'bloc/event_bloc.dart';

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
            return true;
          },
          child: state.events.length > 0
              ? ListView.builder(
                  itemCount: state.events.length,
                  itemBuilder: (BuildContext context, int index) {
                    final event = state.events[index];
                    if (index == 0) {
                      return UpcommingEventCard(
                        event: event,
                      );
                    }
                    return EventCard(event: event);
                  })
              : Stack(
                  children: <Widget>[
                    Center(
                      child: Center(child: Text('No events available')),
                    ),
                    ListView()
                  ],
                ),
        );
    }
  }
}

class UpcommingEventCard extends StatelessWidget {
  const UpcommingEventCard({
    Key key,
    @required this.event,
  }) : super(key: key);

  final Event event;

  @override
  Widget build(BuildContext context) {
    var dateWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              DateFormat('MMMM').format(event.date.toDate()),
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(width: 8.0),
            Text(
              DateFormat('dd').format(event.date.toDate()),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        SizedBox(width: 8.0),
        Text(
          DateFormat('HH:mm').format(event.date.toDate()),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20.0,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );

    //AspectRatio(              aspectRatio: 1,
    return Card(
      margin: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Container(
                            child: Text(
                              event.title,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                        ),
                        dateWidget,
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      event.description,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    event.speaker != ""
                        ? Row(
                            children: [
                              Icon(
                                Icons.speaker_notes,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8.0),
                              Text(
                                event.speaker,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            ),
            SizedBox(height: 14.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    event.registrationAmount.toString() + " Angemeldet",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  StreamBuilder(
                    stream: event.registrations,
                    builder: (ctx, snapshot) {
                      return _buildRegistrationButton(ctx, snapshot);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegistrationButton(BuildContext ctx, AsyncSnapshot snapshot) {
    if (!snapshot.hasData || snapshot.data.length == 0) {
      return Container();
    }
    List<Registration> registrations = snapshot.data;
    final userId = ctx.read<UserBloc>().state.user.id;
    if (registrations.where((r) => r.id == userId).length > 0) {
      return ElevatedButton(
        onPressed: () {},
        child: Text(
          'Unregister',
          style: TextStyle(color: Colors.black54),
        ),
        style: ElevatedButton.styleFrom(
          primary: Colors.grey[100],
          textStyle: TextStyle(
            color: Colors.black,
          ),
          shadowColor: Colors.transparent,
        ),
      );
    }

    return ElevatedButton(
      onPressed: () {},
      child: Text(
        'Join Event',
        style: TextStyle(color: Colors.black54),
      ),
      style: ElevatedButton.styleFrom(
        primary: Colors.grey[100],
        textStyle: TextStyle(
          color: Colors.black,
        ),
        shadowColor: Colors.transparent,
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  const EventCard({
    Key key,
    @required this.event,
  }) : super(key: key);

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              height: 80.0,
              width: 80.0,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('MMMM').format(event.date.toDate()),
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      DateFormat('dd').format(event.date.toDate()),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 28.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      event.description,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),
            StreamBuilder(
              stream: event.registrations,
              builder: (ctx, snapshot) {
                return _buildRegistrationButton(ctx, snapshot);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegistrationButton(BuildContext ctx, AsyncSnapshot snapshot) {
    if (!snapshot.hasData) {
      return Container();
    }
    List<Registration> registrations = snapshot.data;
    final userId = ctx.read<UserBloc>().state.user.id;
    if (registrations.where((r) => r.id == userId).length > 0) {
      return ElevatedButton(
        onPressed: () {},
        child: Text(
          'Unregister',
          style: TextStyle(color: Colors.black54),
        ),
        style: ElevatedButton.styleFrom(
          primary: Colors.grey[100],
          textStyle: TextStyle(
            color: Colors.black,
          ),
          shadowColor: Colors.transparent,
        ),
      );
    }
    return ElevatedButton(
      onPressed: () {},
      child: Text(
        'Join',
        style: TextStyle(color: Colors.black54),
      ),
      style: ElevatedButton.styleFrom(
        primary: Colors.grey[100],
        textStyle: TextStyle(
          color: Colors.black,
        ),
        shadowColor: Colors.transparent,
      ),
    );
  }
}
/*
ElevatedButton(
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
 */
