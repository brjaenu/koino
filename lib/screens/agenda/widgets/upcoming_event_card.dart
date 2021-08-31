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
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            Text(
              DateFormat('MMM').format(event.date.toDate()).toUpperCase(),
              style: Theme.of(context).accentTextTheme.headline3,
              textAlign: TextAlign.center,
            ),
            Text(
              DateFormat('dd').format(event.date.toDate()),
              style: Theme.of(context).accentTextTheme.headline3,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        Text(
          DateFormat('HH:mm').format(event.date.toDate()),
          style: Theme.of(context).accentTextTheme.headline3,
          textAlign: TextAlign.center,
        ),
      ],
    );

    var speakerWidget = event.speaker != ""
        ? Row(
            children: [
              Icon(
                Icons.speaker_notes,
                color: Colors.white,
              ),
              SizedBox(width: 10.0),
              Text(
                event.speaker,
                style: Theme.of(context).accentTextTheme.bodyText1,
              ),
            ],
          )
        : Container();

    var titleWidget = Text(
      event.title,
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
      style: Theme.of(context).accentTextTheme.headline3,
    );
    var descriptionWidget = Text(
      event.description,
      style: Theme.of(context).accentTextTheme.bodyText1,
    );
    var registeredBubblesWidget = CircleAvatar(
      maxRadius: 15.0,
      backgroundColor: Theme.of(context).primaryColor,
      child: Text(
        "+" + event.registrationAmount.toString(),
        style: Theme.of(context).accentTextTheme.bodyText1.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );

    return BlocConsumer<RegisterEventCubit, RegisterEventState>(
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
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        titleWidget,
                                        SizedBox(height: 10.0),
                                        speakerWidget,
                                      ],
                                    ),
                                  ),
                                ),
                                dateWidget,
                              ],
                            ),
                            SizedBox(height: 10.0),
                            descriptionWidget,
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        registeredBubblesWidget,
                        _buildRegistrationButton(context, isRegistered, state),
                      ],
                    )
                  ],
                ),
              ),
              Positioned(
                top: 0,
                right: 10.0,
                child: buildBookmarkIfRegistered(context, isRegistered, state),
              ),
            ],
          ),
        );
      },
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
          'Abmelden',
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
        'Anmelden',
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
      final username = context.read<UserBloc>().state.user.username;

      context.read<RegisterEventCubit>().registerForEvent(
          eventId: eventId, userId: userId, username: username);
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
            color: Theme.of(context).primaryColor,
            size: 40.0,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: FaIcon(
              FontAwesomeIcons.solidStar,
              color: Colors.white,
              size: 15.0,
            ),
          ),
        ],
      ),
    );
  }
}
