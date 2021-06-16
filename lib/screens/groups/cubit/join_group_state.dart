part of 'join_group_cubit.dart';

enum JoinGroupStatus { initial, submitting, success, error }

class JoinGroupState extends Equatable {
  final String name;
  final String activationCode;
  final JoinGroupStatus status;
  final Failure failure;

  JoinGroupState({
    @required this.name,
    @required this.activationCode,
    @required this.status,
    @required this.failure,
  });

  bool get isFormValid =>
      name.isNotEmpty &&
      name.length >= 4 &&
      activationCode.isNotEmpty &&
      activationCode.length >= 8;

  factory JoinGroupState.initial() {
    return JoinGroupState(
      name: '',
      activationCode: '',
      status: JoinGroupStatus.initial,
      failure: const Failure(),
    );
  }

  @override
  List<Object> get props => [name, activationCode, status, failure];

  @override
  bool get stringify => true;

  JoinGroupState copyWith({
    String name,
    String activationCode,
    JoinGroupStatus status,
    Failure failure,
  }) {
    return JoinGroupState(
      name: name ?? this.name,
      activationCode: activationCode ?? this.activationCode,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
