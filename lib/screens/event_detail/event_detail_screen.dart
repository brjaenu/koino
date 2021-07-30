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
    return Scaffold(
      appBar: AppBar(
        title: Text(event.title),
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
            children: [
              Card(
                margin: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Container(
                                      child: Text(
                                        state.event.title,
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
                                  Column(
                                    children: [
                                      Text(
                                          DateFormat('dd.MMM')
                                              .format(event.date.toDate()),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white)),
                                      Text(
                                          DateFormat('HH:mm')
                                              .format(event.date.toDate()),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white))
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(height: 16.0),
                              Text(
                                state.event.description,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 16.0),
                              state.event.speaker != ""
                                  ? Row(
                                      children: [
                                        Icon(
                                          Icons.speaker_notes,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 8.0),
                                        Text(
                                          state.event.speaker,
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
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              buildBookmarkIfRegistered(
                                  context, state.event.registeredUsers),
                              Text(
                                state.event.registrationAmount.toString() +
                                    " Angemeldet",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Divider(),
                      Column(
                        children: [
                          Wrap(
                            alignment: WrapAlignment.start,
                            children: [
                              ...state.registrations
                                  .map((registration) => Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: CustomChip(
                                          label: registration.username,
                                          isHighlighted: registration.id ==
                                              context
                                                  .read<UserBloc>()
                                                  .state
                                                  .user
                                                  .id,
                                        ),
                                  ))
                                  .toList()
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
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
