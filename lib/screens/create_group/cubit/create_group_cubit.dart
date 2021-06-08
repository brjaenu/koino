import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:koino/models/models.dart';
import 'package:koino/repositories/group/group_repository.dart';

part 'create_group_state.dart';

class CreateGroupCubit extends Cubit<CreateGroupState> {
  final GroupRepository _groupRepository;

  CreateGroupCubit({
    @required groupRepository,
  })  : _groupRepository = groupRepository,
        super(CreateGroupState.initial());

  void nameChanged(String value) {
    emit(state.copyWith(
      name: value,
      status: CreateGroupStatus.initial,
    ));
  }

  void activationCodeChanged(String value) {
    emit(state.copyWith(
      activationCode: value,
      status: CreateGroupStatus.initial,
    ));
  }

  Future<Group> createGroup({String ownerId}) async {
    if (!state.isFormValid || state.status == CreateGroupStatus.submitting)
      return null;
    try {
      emit(state.copyWith(status: CreateGroupStatus.submitting));
      final group = await _groupRepository.create(
        name: state.name,
        activationCode: state.activationCode,
        ownerId: ownerId,
      );
      emit(state.copyWith(status: CreateGroupStatus.success));
      return group;
    } catch (err) {
      emit(state.copyWith(
        status: CreateGroupStatus.error,
        failure: err,
      ));
    }
    return null;
  }
}
