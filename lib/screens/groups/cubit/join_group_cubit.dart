import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:koino/models/models.dart';
import 'package:koino/repositories/group/group_repository.dart';

part 'join_group_state.dart';

class JoinGroupCubit extends Cubit<JoinGroupState> {
  final GroupRepository _groupRepository;

  JoinGroupCubit({
    @required groupRepository,
  })  : _groupRepository = groupRepository,
        super(JoinGroupState.initial());

  void nameChanged(String value) {
    emit(state.copyWith(
      name: value,
      status: JoinGroupStatus.initial,
    ));
  }

  void activationCodeChanged(String value) {
    emit(state.copyWith(
      activationCode: value,
      status: JoinGroupStatus.initial,
    ));
  }

  Future<Group> joinGroup({String userId}) async {
    if (!state.isFormValid || state.status == JoinGroupStatus.submitting)
      return null;
    try {
      emit(state.copyWith(status: JoinGroupStatus.submitting));
      final group = await _groupRepository.findByNameAndActivationCode(
        name: state.name,
        activationCode: state.activationCode,
      );
      if (group == null) {
        emit(state.copyWith(
          status: JoinGroupStatus.error,
          failure: new Failure(message: 'No group found with given arguments.'),
        ));
      }
      await _groupRepository.addMember(groupId: group.id, userId: userId);
      emit(state.copyWith(status: JoinGroupStatus.success));
      return group;
    } catch (err) {
      emit(state.copyWith(
        status: JoinGroupStatus.error,
        failure: err,
      ));
    }
    return null;
  }
}
