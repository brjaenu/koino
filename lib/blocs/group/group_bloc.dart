import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:koino/models/models.dart';
import 'package:koino/repositories/group/group_repository.dart';

part 'group_event.dart';
part 'group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final GroupRepository _groupRepository;

  StreamSubscription<List<Future<Group>>> _groupsSubscription;

  GroupBloc({@required GroupRepository groupRepository})
      : _groupRepository = groupRepository,
        super(GroupState.initial());

  @override
  Future<void> close() {
    _groupsSubscription.cancel();
    return super.close();
  }

  @override
  Stream<GroupState> mapEventToState(
    GroupEvent event,
  ) async* {
    if (event is LoadUserGroups) {
      yield* _mapLoadUserGroupsToState(event);
    } else if (event is LoadActiveGroup) {
      yield* _mapLoadActiveGroupToState(event);
    }
  }

  Stream<GroupState> _mapLoadUserGroupsToState(LoadUserGroups event) async* {
    yield state.copyWith(status: GroupStatus.loading);
    try {
      final groups = await _groupRepository.findByUserId(userId: event.userId);
      

      _groupsSubscription?.cancel();
      _groupsSubscription = _groupRepository.findByUserId(userId: event.userId).listen((groups) async {
        final userGroups = await Future.wait(groups);
      });

      
      yield state.copyWith(
        userGroups: groups,
        status: GroupStatus.loaded,
      );
    } catch (err) {
      yield state.copyWith(
        status: GroupStatus.failure,
        failure: const Failure(message: 'Unable to load groups of this user.'),
      );
    }
  }

  Stream<GroupState> _mapLoadActiveGroupToState(LoadActiveGroup event) async* {
    yield state.copyWith(status: GroupStatus.loading);
    try {
      final group = await _groupRepository.findById(id: event.groupId);
      yield state.copyWith(
        activeGroup: group,
        status: GroupStatus.loaded,
      );
    } catch (err) {
      yield state.copyWith(
        status: GroupStatus.failure,
        failure:
            const Failure(message: 'Unable to load active group of this user.'),
      );
    }
  }
}
