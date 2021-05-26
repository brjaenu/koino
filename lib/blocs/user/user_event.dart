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
