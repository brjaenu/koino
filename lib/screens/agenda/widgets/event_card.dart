import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koino/blocs/blocs.dart';
import 'package:koino/models/models.dart';
import 'package:koino/screens/agenda/cubit/register_event_cubit.dart';
import 'package:koino/widgets/widgets.dart';

class EventCard extends StatelessWidget {
  const EventCard({
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

    var eventCard = BlocConsumer<RegisterEventCubit, RegisterEventState>(
      listener: (context, state) {
        if (state.status == RegisterEventStatus.error) {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(content: state.failure.message),
          );
        }
      },
      builder: (context, state) {
        return Card(
          margin: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
          child: Stack(
            children: [
              Padding(
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
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
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
                    _buildRegistrationButton(context, isRegistered, state),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: buildBookmarkIfRegistered(context, isRegistered, state),
              ),
            ],
          ),
        );
      },
    );
    return eventCard;
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
