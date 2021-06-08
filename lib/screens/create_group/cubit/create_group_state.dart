part of 'create_group_cubit.dart';

enum CreateGroupStatus { initial, submitting, success, error }

class CreateGroupState extends Equatable {
  final String name;
  final String activationCode;
  final CreateGroupStatus status;
  final Failure failure;

  const CreateGroupState({
    @required this.name,
    @required this.activationCode,
    @required this.status,
    @required this.failure,
  });

  bool get isFormValid =>
      name.isNotEmpty &&
      name.length >= 3 &&
      activationCode.isNotEmpty &&
      activationCode.length >= 8;

  factory CreateGroupState.initial() {
    return CreateGroupState(
      name: '',
      activationCode: '',
      status: CreateGroupStatus.initial,
      failure: const Failure(),
    );
  }

  @override
  List<Object> get props => [name, activationCode, status, failure];

  @override
  bool get stringify => true;

  CreateGroupState copyWith({
    String name,
    String activationCode,
    CreateGroupStatus status,
    Failure failure,
  }) {
    return CreateGroupState(
      name: name ?? this.name,
      activationCode: activationCode ?? this.activationCode,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
