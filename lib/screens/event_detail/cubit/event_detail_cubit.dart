import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:koino/models/models.dart';
import 'package:koino/repositories/repositories.dart';

part 'event_detail_state.dart';

class EventDetailCubit extends Cubit<EventDetailState> {
  final EventRepository _eventRepository;
  final RegistrationRepository _registrationRepository;

  EventDetailCubit({
    @required EventRepository eventRepository,
    @required RegistrationRepository registrationRepository,
  })  : _eventRepository = eventRepository,
        _registrationRepository = registrationRepository,
        super(EventDetailState.initial());

  void loadDetails(Event event) async {
    if (event == null) {
      emit(state.copyWith(
        status: EventDetailStatus.error,
        failure: const Failure(message: 'No event available'),
      ));
      return;
    }
    try {
      emit(state.copyWith(
        status: EventDetailStatus.loading,
      ));
      _registrationRepository
          .findByEventIdStream(eventId: event.id)
          .listen((registrations) {
        emit(state.copyWith(
          registrations: registrations,
          status: EventDetailStatus.loaded,
        ));
        emit(state.copyWith(
          event: event,
          status: EventDetailStatus.loaded,
        ));
      });
    } catch (err) {
      emit(state.copyWith(
        status: EventDetailStatus.error,
        failure: err,
      ));
    }
  }
}
