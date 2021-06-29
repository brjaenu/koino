import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:koino/blocs/blocs.dart';
import 'package:koino/models/models.dart';
import 'package:koino/repositories/repositories.dart';

part 'event_event.dart';
part 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final EventRepository _eventRepository;
  final UserBloc _userBloc;

  EventBloc({
    @required EventRepository eventRepository,
    @required UserBloc userBloc,
  })  : _eventRepository = eventRepository,
        _userBloc = userBloc,
        super(EventState.initial());

  @override
  Stream<EventState> mapEventToState(
    EventEvent event,
  ) async* {
    if (event is EventFetchEvents) {
      yield* _mapEventFetchEventsToState();
    } else if (event is EventPaginateEvents) {
      yield* _mapEventPaginateEventsToState();
    }
  }

  Stream<EventState> _mapEventFetchEventsToState() async* {
    yield state
        .copyWith(events: [], status: EventStatus.loading, failure: null);

    try {
      final events = await _eventRepository.findByGroupId(
          groupId: _userBloc.state.user.activeGroup.id);

      yield state.copyWith(
        events: events,
        status: EventStatus.loaded,
      );
    } catch (err) {
      print(err);
      yield state.copyWith(
        status: EventStatus.error,
        failure: const Failure(message: 'Unable to load events'),
      );
    }
  }

  Stream<EventState> _mapEventPaginateEventsToState() async* {
    yield state.copyWith(status: EventStatus.paginating);
    try {
      // TODO: Implement pagination
    } catch (err) {
      yield state.copyWith(
        status: EventStatus.error,
        failure: const Failure(message: 'Unable to load events'),
      );
    }
  }
}
