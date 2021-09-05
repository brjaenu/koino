import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:koino/blocs/user/user_bloc.dart';
import 'package:koino/models/failure_model.dart';
import 'package:koino/models/models.dart';
import 'package:koino/repositories/prayer/prayer_repository.dart';

part 'create_prayer_state.dart';

class CreatePrayerCubit extends Cubit<CreatePrayerState> {
  final PrayerRepository _prayerRepository;
  final UserBloc _userBloc;

  CreatePrayerCubit({
    @required prayerRepository,
    @required userBloc,
  })  : _prayerRepository = prayerRepository,
        _userBloc = userBloc,
        super(CreatePrayerState.initial());

  void titleChanged(String value) {
    emit(state.copyWith(
      title: value,
      status: CreatePrayerStatus.initial,
    ));
  }

  void descriptionChanged(String value) {
    emit(state.copyWith(
      description: value,
      status: CreatePrayerStatus.initial,
    ));
  }

  void isAnonymousChanged(bool value) {
    emit(state.copyWith(
      isAnonymous: value,
      status: CreatePrayerStatus.initial,
    ));
  }

  Future<Prayer> createPrayer({String authorId, String groupId}) async {
    if (!state.isFormValid || state.status == CreatePrayerStatus.submitting) {
      return null;
    }
    try {
      emit(state.copyWith(status: CreatePrayerStatus.submitting));
      final String username =
          state.isAnonymous ? '' : _userBloc.state.user.username;
      final prayer = await _prayerRepository.create(
        title: state.title,
        description: state.description,
        isAnonymous: state.isAnonymous,
        username: username,
        authorId: authorId,
        groupId: groupId,
      );
      if (prayer == null) {
        emit(state.copyWith(
          status: CreatePrayerStatus.error,
          failure: new Failure(message: 'Prayer already exists.'),
        ));
      }
      emit(state.copyWith(status: CreatePrayerStatus.success));
      return prayer;
    } catch (err) {
      emit(state.copyWith(
        status: CreatePrayerStatus.error,
        failure: err,
      ));
    }
    return null;
  }
}
