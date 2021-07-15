import 'package:flutter/material.dart';
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
                                  //dateWidget,
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
                          //_buildRegistrationButton(context, snapshot, state),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              state.event.registeredUsers.length > 0
                  ? Card(
                      margin: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Angemeldet sind...',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                            Wrap(
                              children: [
                                ...state.registrations
                                    .map((registration) => CustomChip(
                                          label: registration.username,
                                          isHighlighted: registration.id ==
                                              context
                                                  .read<UserBloc>()
                                                  .state
                                                  .user
                                                  .id,
                                        ))
                                    .toList()
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
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
