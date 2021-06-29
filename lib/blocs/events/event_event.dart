part of 'event_bloc.dart';

class EventEvent extends Equatable {
  const EventEvent();

  @override
  List<Object> get props => [];
}

class EventFetchEvents extends EventEvent {}

class EventPaginateEvents extends EventEvent {}
