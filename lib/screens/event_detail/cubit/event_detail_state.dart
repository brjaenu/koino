part of 'event_detail_cubit.dart';

enum EventDetailStatus { initial, loading, loaded, error }

class EventDetailState extends Equatable {
  final Event event;
  final List<Registration> registrations;
  final EventDetailStatus status;
  final Failure failure;

  EventDetailState({
    @required this.event,
    @required this.registrations,
    @required this.status,
    @required this.failure,
  });

  factory EventDetailState.initial() {
    return EventDetailState(
      event: Event.empty,
      registrations: List.empty(),
      status: EventDetailStatus.initial,
      failure: const Failure(),
    );
  }

  @override
  List<Object> get props => [event, registrations, status, failure];

  EventDetailState copyWith({
    Event event,
    List<Registration> registrations,
    EventDetailStatus status,
    Failure failure,
  }) {
    return EventDetailState(
      event: event ?? this.event,
      registrations: registrations ?? this.registrations,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
