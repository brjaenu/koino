import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:koino/models/event_model.dart';

import 'package:koino/models/failure_model.dart';
import 'package:koino/repositories/event/event_repository.dart';

part 'create_event_state.dart';

class CreateEventCubit extends Cubit<CreateEventState> {
  final EventRepository _eventRepository;

  CreateEventCubit({
    @required eventRepository,
  })  : _eventRepository = eventRepository,
        super(CreateEventState.initial());

  void titleChanged(String value) {
    emit(state.copyWith(
      title: value,
      status: CreateEventStatus.initial,
    ));
  }

  void descriptionChanged(String value) {
    emit(state.copyWith(
      description: value,
      status: CreateEventStatus.initial,
    ));
  }

  void speakerChanged(String value) {
    emit(state.copyWith(
      speaker: value,
      status: CreateEventStatus.initial,
    ));
  }

  void dateChanged(DateTime value) {
    emit(state.copyWith(
      date: Timestamp.fromDate(value),
      status: CreateEventStatus.initial,
    ));
  }

  Future<Event> createEvent({String authorId, String groupId}) async {
    if (!state.isFormValid || state.status == CreateEventStatus.submitting) {
      return null;
    }
    try {
      emit(state.copyWith(status: CreateEventStatus.submitting));
      final event = await _eventRepository.create(
        title: state.title,
        description: state.description,
        speaker: state.speaker,
        date: state.date,
        authorId: authorId,
        groupId: groupId,
      );
      if (event == null) {
        emit(state.copyWith(
          status: CreateEventStatus.error,
          failure: new Failure(message: 'Event already exists.'),
        ));
      }
      emit(state.copyWith(status: CreateEventStatus.success));
      return event;
    } catch (err) {
      emit(state.copyWith(
        status: CreateEventStatus.error,
        failure: err,
      ));
    }
    return null;
  }
}
