part of 'event_bloc.dart';

class EventEvent extends Equatable {
  const EventEvent();

  @override
  List<Object> get props => [];
}

class EventCreateEventStream extends EventEvent {}

class EventProcessEventStream extends EventEvent {
  final List<Event> events;

  EventProcessEventStream({
    @required this.events,
  });

  @override
  List<Object> get props => [events];
}

class EventFetchEvents extends EventEvent {}
