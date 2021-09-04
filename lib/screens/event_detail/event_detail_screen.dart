import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:koino/blocs/blocs.dart';
import 'package:koino/models/models.dart';
import 'package:koino/screens/event_detail/cubit/event_detail_cubit.dart';
import 'package:koino/screens/event_detail/widgets/custom_chip.dart';
import 'package:koino/widgets/widgets.dart';

class EventDetailScreen extends StatelessWidget {
  const EventDetailScreen({
    Key key,
    @required this.event,
  }) : super(key: key);

  final Event event;

  @override
  Widget build(BuildContext context) {
    context.read<EventDetailCubit>().loadDetails(eventId: event.id);

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

    return Scaffold(
      appBar: AppBar(
        title: Text('EVENT DETAILS'),
      ),
      body: BlocConsumer<EventDetailCubit, EventDetailState>(
        listener: (context, state) {
          if (state.status == EventStatus.error) {
            showDialog(
              context: context,
              builder: (context) => ErrorDialog(content: state.failure.message),
            );
          }
        },
        builder: (context, state) {
          return ListView(
            padding: EdgeInsets.fromLTRB(24.0, 10.0, 24.0, 10.0),
            children: [
              Card(
                margin: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).accentColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16.0)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                        ],
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 10.0,
                      child: buildBookmarkIfRegistered(
                          context, state.event.registeredUsers),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 25.0,
              ),
              Divider(
                color: Theme.of(context).primaryColorDark,
                thickness: 2.0,
                indent: 30.0,
                endIndent: 30.0,
              ),
              SizedBox(
                height: 25.0,
              ),
              Text(
                "EVENTANGEMELDUNGEN",
                style: Theme.of(context).textTheme.headline3,
              ),
              SizedBox(
                height: 10.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    alignment: WrapAlignment.start,
                    children: [
                      ...state.registrations
                          .map((registration) => CustomChip(
                                label: registration.username.toUpperCase(),
                                isHighlighted: registration.id ==
                                    context.read<UserBloc>().state.user.id,
                              ))
                          .toList()
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildBookmarkIfRegistered(
      BuildContext context, List<String> registrations) {
    var userId = context.read<UserBloc>().state.user.id;
    if (registrations.isEmpty || !registrations.contains(userId)) {
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
