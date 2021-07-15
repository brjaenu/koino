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

  StreamSubscription<List<Event>> _eventsSubscription;

  EventBloc({
    @required EventRepository eventRepository,
    @required UserBloc userBloc,
  })  : _eventRepository = eventRepository,
        _userBloc = userBloc,
        super(EventState.initial());

  @override
  Future<void> close() {
    _eventsSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<EventState> mapEventToState(
    EventEvent event,
  ) async* {
    if (event is EventCreateEventStream) {
      yield* _mapEventCreateEventStreamToState();
    } else if (event is EventProcessEventStream) {
      yield* _mapEventProcessEventStreamToState(event);
    } else if (event is EventFetchEvents) {
      yield* _mapEventFetchEventsToState();
    }
  }

  Stream<EventState> _mapEventCreateEventStreamToState() async* {
    _eventsSubscription?.cancel();
    _eventsSubscription = _eventRepository
        .streamByGroupId(groupId: _userBloc.state.user.activeGroup.id)
        .listen((events) async {
      add(EventProcessEventStream(events: events));
    });
  }

  Stream<EventState> _mapEventProcessEventStreamToState(
      EventProcessEventStream event) async* {
    yield state.copyWith(
      events: event.events,
    );
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
}
