import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:koino/blocs/blocs.dart';
import 'package:koino/models/models.dart';
import 'package:koino/screens/agenda/cubit/register_event_cubit.dart';
import 'package:koino/widgets/widgets.dart';

class EventDetailScreen extends StatelessWidget {
  const EventDetailScreen({
    Key key,
    @required this.event,
  }) : super(key: key);

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event.title),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          return true;
        },
        child: ListView(
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
                                //dateWidget,
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
                      child: StreamBuilder(
                        stream: event.registrations,
                        builder: (context, snapshot) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  buildBookmarkIfRegistered(context, snapshot),
                                  Text(
                                    calculateRegistrationAmount(snapshot) +
                                        " Angemeldet",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              //_buildRegistrationButton(context, snapshot, state),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
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

  Widget buildBookmarkIfRegistered(
      BuildContext context, AsyncSnapshot snapshot) {
    var userId = context.read<UserBloc>().state.user.id;
    if (!snapshot.hasData ||
        !(snapshot.data.where((r) => r.id == userId).toList().length > 0)) {
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
