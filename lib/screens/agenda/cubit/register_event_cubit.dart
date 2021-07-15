import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:koino/models/models.dart';
import 'package:koino/repositories/repositories.dart';

part 'register_event_state.dart';

class RegisterEventCubit extends Cubit<RegisterEventState> {
  final EventRepository _eventRepository;

  RegisterEventCubit({
    @required EventRepository eventRepository,
  })  : _eventRepository = eventRepository,
        super(RegisterEventState.initial());

  void registerForEvent(
      {String eventId, String userId, String username}) async {
    if (state.status == RegisterEventStatus.submitting) return null;
    try {
      emit(state.copyWith(
        isRegistering: true,
        status: RegisterEventStatus.submitting,
      ));
      await _eventRepository.registerToEvent(
        eventId: eventId,
        userId: userId,
        username: username,
      );
      emit(state.copyWith(status: RegisterEventStatus.success));
    } catch (err) {
      emit(state.copyWith(
        isRegistering: false,
        status: RegisterEventStatus.error,
        failure: err,
      ));
    }
  }

  void unregisterFromEvent({String eventId, String userId}) async {
    if (state.status == RegisterEventStatus.submitting) return null;
    try {
      emit(state.copyWith(
        isUnregistering: true,
        status: RegisterEventStatus.submitting,
      ));
      await _eventRepository.unregisterFromEvent(
          eventId: eventId, userId: userId);
      emit(state.copyWith(status: RegisterEventStatus.success));
    } catch (err) {
      emit(state.copyWith(
        isUnregistering: false,
        status: RegisterEventStatus.error,
        failure: err,
      ));
    }
  }

  void transmittingComplete() async {
    emit(state.copyWith(
      isRegistering: false,
      isUnregistering: false,
    ));
  }
}
