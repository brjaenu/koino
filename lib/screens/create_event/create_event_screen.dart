import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koino/blocs/blocs.dart';
import 'package:koino/models/models.dart';
import 'package:koino/repositories/repositories.dart';
import 'package:koino/screens/create_group/cubit/create_group_cubit.dart';
import 'package:koino/screens/nav/cubit/bottom_nav_bar_cubit.dart';
import 'package:koino/widgets/widgets.dart';

import 'cubit/create_event_cubit.dart';

class CreateEventScreen extends StatelessWidget {
  static const String routeName = '/create-event';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<CreateEventCubit>(
        create: (_) => CreateEventCubit(
          eventRepository: context.read<EventRepository>(),
        ),
        child: CreateEventScreen(),
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();
  final _titleFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _speakerFocusNode = FocusNode();
  final _dateFocusNode = FocusNode();

  final format = DateFormat("dd.MM.yyyy HH:mm");

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BlocConsumer<CreateEventCubit, CreateEventState>(
        listener: (context, state) {
          if (state.status == CreateEventStatus.error) {
            showDialog(
              context: context,
              builder: (context) => ErrorDialog(content: state.failure.message),
            );
          }
        },
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () async => _popGroupsRoute(context),
            child: Scaffold(
              appBar: AppBar(
                title: Text('EVENT ERSTELLEN'),
              ),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: ListView(
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 25.0),
                            TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                hintText: 'TITEL',
                                prefixIcon: Icon(
                                  FontAwesomeIcons.tag,
                                  color: Theme.of(context).iconTheme.color,
                                  size: 20.0,
                                ),
                              ),
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.name,
                              focusNode: _titleFocusNode,
                              onChanged: (value) => context
                                  .read<CreateEventCubit>()
                                  .titleChanged(value),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter a title.';
                                }
                                if (value.toString().length < 3) {
                                  return 'The title must be at least 3 characters long.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 25.0),
                            TextFormField(
                              maxLines: 5,
                              minLines: 2,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                hintText: 'BESCHREIBUNG',
                                prefixIcon: Icon(
                                  FontAwesomeIcons.stream,
                                  color: Theme.of(context).iconTheme.color,
                                  size: 20.0,
                                ),
                              ),
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.text,
                              focusNode: _descriptionFocusNode,
                              onChanged: (value) => context
                                  .read<CreateEventCubit>()
                                  .descriptionChanged(value),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter a description.';
                                }
                                if (value.toString().length < 5) {
                                  return 'The description must be at least 5 characters long.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 25.0),
                            TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                hintText: 'SPEAKER',
                                prefixIcon: Icon(
                                  FontAwesomeIcons.solidComment,
                                  color: Theme.of(context).iconTheme.color,
                                  size: 20.0,
                                ),
                              ),
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.name,
                              focusNode: _speakerFocusNode,
                              onChanged: (value) => context
                                  .read<CreateEventCubit>()
                                  .speakerChanged(value),
                              validator: (value) {
                                if (value.toString().length > 0 &&
                                    value.toString().length < 3) {
                                  return 'The speaker name must be at least 3 characters long.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 25.0),
                            DateTimeField(
                                format: format,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                  hintText: 'DATUM UND UHRZEIT',
                                  prefixIcon: Icon(
                                    FontAwesomeIcons.clock,
                                    color: Theme.of(context).iconTheme.color,
                                    size: 20.0,
                                  ),
                                ),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.datetime,
                                focusNode: _dateFocusNode,
                                onShowPicker: (context, currentValue) async {
                                  final date = await showDatePicker(
                                      context: context,
                                      firstDate: DateTime(1900),
                                      initialDate:
                                          currentValue ?? DateTime.now(),
                                      lastDate: DateTime(2100));
                                  if (date != null) {
                                    final time = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.fromDateTime(
                                          currentValue ?? DateTime.now()),
                                    );
                                    return DateTimeField.combine(date, time);
                                  } else {
                                    return currentValue;
                                  }
                                },
                                onChanged: (value) => context
                                    .read<CreateEventCubit>()
                                    .dateChanged(value),
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please enter the date of the event.';
                                  }
                                  if (!value.isAfter(DateTime.now())) {
                                    return 'The datetime must be after the current date and time.';
                                  }
                                  return null;
                                }),
                            const SizedBox(height: 25.0),
                            ElevatedButton(
                              onPressed: () => _submitForm(context,
                                  state.status == CreateGroupStatus.submitting),
                              child: Text('ERSTELLEN'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  _submitForm(BuildContext context, bool isSubmitting) async {
    final User user = context.read<UserBloc>().state.user;

    if (_formKey.currentState.validate() && !isSubmitting) {
      final event = await context
          .read<CreateEventCubit>()
          .createEvent(authorId: user.id, groupId: user.activeGroup.id);
      if (event == null) {
        return;
      }
      _popGroupsRoute(context);
    }
  }

  Future<bool> _popGroupsRoute(BuildContext context) async {
    context.read<BottomNavBarCubit>().updateNavBarVisibility(isVisible: true);
    Navigator.of(context).pop();
    return Future.value(true);
  }
}
