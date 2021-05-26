import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:koino/models/models.dart';
import 'package:koino/models/user_model.dart';
import 'package:koino/repositories/repositories.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository _userRepository;

  ProfileBloc({@required UserRepository userRepository})
      : _userRepository = userRepository,
        super(ProfileState.initial());

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if (event is ProfileLoadUser) {
      yield* _mapProfileLoadUserToState(event);
    }
  }

  Stream<ProfileState> _mapProfileLoadUserToState(
      ProfileLoadUser event) async* {
    yield state.copyWith(status: ProfileStatus.loading);
    try {
      final user = await _userRepository.findById(id: event.userId);
      yield state.copyWith(
        user: user,
        status: ProfileStatus.loaded,
      );
    } catch (err) {
      yield state.copyWith(
        status: ProfileStatus.failure,
        failure: const Failure(message: 'We were unable to load this profile'),
      );
    }
  }
}
