part of 'event_bloc.dart';

enum EventStatus { initial, loading, loaded, paginating, error }

class EventState extends Equatable {
  final List<Event> events;
  final EventStatus status;
  final Failure failure;

  EventState({
    @required this.events,
    @required this.status,
    @required this.failure,
  });

  factory EventState.initial() {
    return EventState(
      events: [],
      status: EventStatus.initial,
      failure: null,
    );
  }

  @override
  List<Object> get props => [events, status, failure];

  EventState copyWith({
    List<Event> events,
    EventStatus status,
    Failure failure,
  }) {
    return EventState(
      events: events ?? this.events,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
