import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koino/blocs/blocs.dart';
import 'package:koino/models/models.dart';
import 'package:koino/screens/agenda/cubit/register_event_cubit.dart';
import 'package:koino/widgets/widgets.dart';

class UpcomingEventCard extends StatelessWidget {
  const UpcomingEventCard({
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
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              maxRadius: 20.0,
                              backgroundColor: Color.fromRGBO(0, 0, 0, 0.1),
                              child: FaIcon(
                                FontAwesomeIcons.calendarCheck,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 8.0),
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
                          ],
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
              child: BlocConsumer<RegisterEventCubit, RegisterEventState>(
                listener: (context, state) {
                  if (state.status == RegisterEventStatus.error) {
                    showDialog(
                      context: context,
                      builder: (context) =>
                          ErrorDialog(content: state.failure.message),
                    );
                  }
                },
                builder: (context, state) {
                  return StreamBuilder(
                      stream: event.registrations,
                      builder: (context, snapshot) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              calculateRegistrationAmount(snapshot) +
                                  " Angemeldet",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            _buildRegistrationButton(context, snapshot, state),
                          ],
                        );
                      });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String calculateRegistrationAmount(AsyncSnapshot snapshot) {
    if (!snapshot.hasData) {
      return "0";
    }
    List<Registration> registrations = snapshot.data;
    var registrationAmount =
        registrations.map((r) => r.additionalAmount).reduce((a, b) => a + b) +
            registrations.length;
    return registrationAmount.toString();
  }

  Widget _buildRegistrationButton(
      BuildContext ctx, AsyncSnapshot snapshot, RegisterEventState state) {
    if (!snapshot.hasData) {
      return Container();
    }
    List<Registration> registrations = snapshot.data;
    final userId = ctx.read<UserBloc>().state.user.id;
    if (registrations.where((r) => r.id == userId).toList().length > 0) {
      return ElevatedButton(
        onPressed: () => _unregister(
            ctx, event.id, state.status == RegisterEventStatus.submitting),
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
      onPressed: () => _register(
          ctx, event.id, state.status == RegisterEventStatus.submitting),
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

  _register(BuildContext context, String eventId, bool isSubmitting) {
    if (!isSubmitting) {
      final userId = context.read<UserBloc>().state.user.id;
      context
          .read<RegisterEventCubit>()
          .registerForEvent(eventId: eventId, userId: userId);
    }
  }

  _unregister(BuildContext context, String eventId, bool isSubmitting) {
    if (!isSubmitting) {
      final userId = context.read<UserBloc>().state.user.id;
      context
          .read<RegisterEventCubit>()
          .unregisterFromEvent(eventId: eventId, userId: userId);
    }
  }
}
