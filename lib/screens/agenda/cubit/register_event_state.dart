part of 'register_event_cubit.dart';

enum RegisterEventStatus { initial, submitting, success, error }

class RegisterEventState extends Equatable {
  final RegisterEventStatus status;
  final Failure failure;

  RegisterEventState({
    @required this.status,
    @required this.failure,
  });

  factory RegisterEventState.initial() {
    return RegisterEventState(
      status: RegisterEventStatus.initial,
      failure: const Failure(),
    );
  }

  @override
  List<Object> get props => [status, failure];

  RegisterEventState copyWith({
    RegisterEventStatus status,
    Failure failure,
  }) {
    return RegisterEventState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
