part of 'register_event_cubit.dart';

enum RegisterEventStatus { initial, submitting, success, error }

class RegisterEventState extends Equatable {
  final bool isRegistering;
  final bool isUnregistering;
  final RegisterEventStatus status;
  final Failure failure;

  RegisterEventState({
    @required this.isRegistering,
    @required this.isUnregistering,
    @required this.status,
    @required this.failure,
  });

  factory RegisterEventState.initial() {
    return RegisterEventState(
      isRegistering: false,
      isUnregistering: false,
      status: RegisterEventStatus.initial,
      failure: const Failure(),
    );
  }

  @override
  List<Object> get props => [isRegistering, isUnregistering, status, failure];

  RegisterEventState copyWith({
    bool isRegistering,
    bool isUnregistering,
    RegisterEventStatus status,
    Failure failure,
  }) {
    return RegisterEventState(
      isRegistering: isRegistering ?? this.isRegistering,
      isUnregistering: isUnregistering ?? this.isUnregistering,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
