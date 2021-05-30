part of 'group_bloc.dart';

abstract class GroupEvent extends Equatable {
  const GroupEvent();

  @override
  List<Object> get props => [];
}

class LoadUserGroups extends GroupEvent {
  final String userId;

  LoadUserGroups({@required this.userId});

  @override
  List<Object> get props => [userId];
}

class LoadActiveGroup extends GroupEvent {
  final String groupId;

  LoadActiveGroup({@required this.groupId});

  @override
  List<Object> get props => [groupId];
}
