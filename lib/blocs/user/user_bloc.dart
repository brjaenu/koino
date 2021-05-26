import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:koino/models/models.dart';
import 'package:koino/models/user_model.dart';
import 'package:koino/repositories/repositories.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository;

  UserBloc({@required UserRepository userRepository})
      : _userRepository = userRepository,
        super(UserState.initial());

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    if (event is LoadUser) {
      yield* _mapLoadUserToState(event);
    }
  }

  Stream<UserState> _mapLoadUserToState(LoadUser event) async* {
    yield state.copyWith(status: UserStatus.loading);
    try {
      final user = await _userRepository.findById(id: event.userId);
      yield state.copyWith(
        user: user,
        status: UserStatus.loaded,
      );
    } catch (err) {
      yield state.copyWith(
        status: UserStatus.failure,
        failure: const Failure(message: 'We were unable to load this user'),
      );
    }
  }
}
