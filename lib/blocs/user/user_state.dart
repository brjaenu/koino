part of 'user_bloc.dart';

enum UserStatus { initial, loading, loaded, failure }

class UserState extends Equatable {
  final User user;
  final UserStatus status;
  final Failure failure;

  const UserState({
    @required this.user,
    @required this.status,
    @required this.failure,
  });

  factory UserState.initial() {
    return UserState(
      user: User.empty,
      status: UserStatus.initial,
      failure: Failure(),
    );
  }

  @override
  List<Object> get props => [
        user,
        status,
        failure,
      ];

  UserState copyWith({
    User user,
    UserStatus status,
    Failure failure,
  }) {
    return UserState(
      user: user ?? this.user,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
