import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:koino/models/models.dart';
import 'package:koino/repositories/group/group_repository.dart';
import 'package:koino/repositories/repositories.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository;
  final GroupRepository _groupRepository;

  StreamSubscription<List<Group>> _groupsSubscription;

  UserBloc({
    @required UserRepository userRepository,
    @required GroupRepository groupRepository,
  })  : _userRepository = userRepository,
        _groupRepository = groupRepository,
        super(UserState.initial());

  @override
  Future<void> close() {
    _groupsSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    if (event is LoadUser) {
      yield* _mapLoadUserToState(event);
    } else if (event is UserUpdateGroups) {
      yield* _mapUserUpdateGroupsToState(event);
    } else if (event is UserUpdateActiveGroup) {
      yield* _mapUserUpdateActiveGroupToState(event);
    }
  }

  Stream<UserState> _mapLoadUserToState(LoadUser event) async* {
    yield state.copyWith(status: UserStatus.loading);
    try {
      final user = await _userRepository.findById(id: event.userId);

      _groupsSubscription?.cancel();
      _groupsSubscription = _groupRepository
          .findByUserId(userId: event.userId)
          .listen((groups) async {
        final userGroups = groups;
        add(UserUpdateGroups(groups: userGroups));
      });

      yield state.copyWith(
        user: user,
        status: UserStatus.loaded,
      );
    } catch (err) {
      yield state.copyWith(
        status: UserStatus.failure,
        failure: const Failure(message: 'Unable to load this user'),
      );
    }
  }

  Stream<UserState> _mapUserUpdateGroupsToState(UserUpdateGroups event) async* {
    yield state.copyWith(
      groups: event.groups,
    );
  }

  Stream<UserState> _mapUserUpdateActiveGroupToState(
      UserUpdateActiveGroup event) async* {
    yield state.copyWith(status: UserStatus.loading);

    try {
      Group activeGroup = await _userRepository.updateActiveGroup(
        userId: state.user.id,
        groupId: event.group.id,
      );

      if (activeGroup == null) {
        yield state.copyWith(
          status: UserStatus.failure,
          failure: const Failure(message: 'Unable to update active group'),
        );
      } else {
        yield state.copyWith(
          user: state.user.copyWith(
            activeGroup: activeGroup,
          ),
          status: UserStatus.loaded,
        );
      }
    } catch (err) {
      yield state.copyWith(
        status: UserStatus.failure,
        failure: const Failure(message: 'Unable to update active group'),
      );
    }
  }
}
