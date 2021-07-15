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
    context.read<RegisterEventCubit>().transmittingComplete();

    final userId = context.read<UserBloc>().state.user.id;
    bool isRegistered =
        event.registeredUsers.where((r) => r == userId).toList().length > 0;
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
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          buildBookmarkIfRegistered(
                              context, isRegistered, state),
                          Text(
                            event.registrationAmount.toString() + " Angemeldet",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      _buildRegistrationButton(context, isRegistered, state),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegistrationButton(
      BuildContext ctx, bool isRegistered, RegisterEventState state) {
    final isRegistering = ctx.read<RegisterEventCubit>().state.isRegistering;
    final isUnregistering =
        ctx.read<RegisterEventCubit>().state.isUnregistering;
    if ((isRegistered && !isUnregistering) || isRegistering) {
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

  Widget buildBookmarkIfRegistered(
      BuildContext context, bool isRegistered, RegisterEventState state) {
    final isRegistering =
        context.read<RegisterEventCubit>().state.isRegistering;

    if (!isRegistered && !isRegistering) {
      return Container();
    }
    return Padding(
      padding: EdgeInsets.only(right: 8.0),
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          FaIcon(
            FontAwesomeIcons.solidBookmark,
            color: Colors.amber,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: FaIcon(
              FontAwesomeIcons.solidStar,
              color: Colors.white,
              size: 12.0,
            ),
          ),
        ],
      ),
    );
  }
}
