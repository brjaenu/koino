part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class LoadUser extends UserEvent {
  final String userId;

  LoadUser({@required this.userId});

  @override
  List<Object> get props => [userId];
}

class UserUpdateGroups extends UserEvent {
  final List<Group> groups;

  UserUpdateGroups({
    @required this.groups,
  });

  @override
  List<Object> get props => [groups];
}

class UserUpdateActiveGroup extends UserEvent {
  final Group group;

  UserUpdateActiveGroup({
    @required this.group,
  });

  @override
  List<Object> get props => [group];
}