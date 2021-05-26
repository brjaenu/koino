part of 'profile_bloc.dart';

enum ProfileStatus { initial, loading, loaded, failure }

class ProfileState extends Equatable {
  final User user;
  final ProfileStatus status;
  final Failure failure;

  const ProfileState({
    @required this.user,
    @required this.status,
    @required this.failure,
  });

  factory ProfileState.initial() {
    return ProfileState(
      user: User.empty,
      status: ProfileStatus.initial,
      failure: Failure(),
    );
  }

  @override
  List<Object> get props => [
        user,
        status,
        failure,
      ];

  ProfileState copyWith({
    User user,
    ProfileStatus status,
    Failure failure,
  }) {
    return ProfileState(
      user: user ?? this.user,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
