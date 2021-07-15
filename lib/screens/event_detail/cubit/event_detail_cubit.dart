import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:koino/models/models.dart';
import 'package:koino/repositories/repositories.dart';

part 'event_detail_state.dart';

class EventDetailCubit extends Cubit<EventDetailState> {
  final EventRepository _eventRepository;
  final RegistrationRepository _registrationRepository;

  StreamSubscription<Event> _eventSubscription;
  StreamSubscription<List<Registration>> _registrationsSubscription;

  @override
  Future<void> close() {
    _eventSubscription?.cancel();
    _registrationsSubscription?.cancel();
    return super.close();
  }

  EventDetailCubit({
    @required EventRepository eventRepository,
    @required RegistrationRepository registrationRepository,
  })  : _eventRepository = eventRepository,
        _registrationRepository = registrationRepository,
        super(EventDetailState.initial());

  void loadDetails({String eventId}) async {
    if (eventId == null) {
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
      _eventSubscription?.cancel();
      _registrationsSubscription?.cancel();

      _eventSubscription =
          _eventRepository.streamByEventId(eventId: eventId).listen((event) {
        emit(state.copyWith(
          event: event,
          status: EventDetailStatus.loaded,
        ));
      });
      _registrationsSubscription = _registrationRepository
          .findByEventIdStream(eventId: eventId)
          .listen((registrations) {
        emit(state.copyWith(
          registrations: registrations,
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
