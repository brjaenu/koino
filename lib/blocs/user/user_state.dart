part of 'user_bloc.dart';

enum UserStatus { initial, loading, loaded, failure }

class UserState extends Equatable {
  final User user;
  final List<Group> groups;
  final UserStatus status;
  final Failure failure;

  const UserState({
    @required this.user,
    @required this.groups,
    @required this.status,
    @required this.failure,
  });

  factory UserState.initial() {
    return UserState(
      user: User.empty,
      groups: List.empty(),
      status: UserStatus.initial,
      failure: Failure(),
    );
  }

  @override
  List<Object> get props => [
        user,
        groups,
        status,
        failure,
      ];

  UserState copyWith({
    User user,
    List<Group> groups,
    Group activeGroup,
    UserStatus status,
    Failure failure,
  }) {
    return UserState(
      user: user ?? this.user,
      groups: groups ?? this.groups,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
