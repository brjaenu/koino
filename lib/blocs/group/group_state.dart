part of 'group_bloc.dart';

enum GroupStatus { initial, loading, loaded, failure }

class GroupState extends Equatable {
  final List<Group> userGroups;
  final Group activeGroup;
  final GroupStatus status;
  final Failure failure;

  const GroupState({
    @required this.userGroups,
    @required this.activeGroup,
    @required this.status,
    @required this.failure,
  });

  factory GroupState.initial() {
    return GroupState(
      userGroups: [],
      activeGroup: Group.empty,
      status: GroupStatus.initial,
      failure: Failure(),
    );
  }

  @override
  List<Object> get props => [
        userGroups,
        activeGroup,
        status,
        failure,
      ];

  GroupState copyWith({
    List<Group> userGroups,
    Group activeGroup,
    GroupStatus status,
    Failure failure,
  }) {
    return GroupState(
      userGroups: userGroups ?? this.userGroups,
      activeGroup: activeGroup ?? this.activeGroup,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
