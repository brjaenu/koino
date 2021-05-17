part of 'signup_cubit.dart';

enum SignupStatus { initial, submitting, success, error }

class SignupState extends Equatable {
  final String username;
  final String email;
  final String password;
  final String passwordRepeat;
  final SignupStatus status;
  final Failure failure;

  bool get isFormValid =>
      username.isNotEmpty &&
      email.isNotEmpty &&
      password.isNotEmpty &&
      passwordRepeat.isNotEmpty &&
      password == passwordRepeat;

  const SignupState({
    @required this.username,
    @required this.email,
    @required this.password,
    @required this.passwordRepeat,
    @required this.status,
    @required this.failure,
  });

  factory SignupState.initial() {
    return SignupState(
      username: '',
      email: '',
      password: '',
      passwordRepeat: '',
      status: SignupStatus.initial,
      failure: const Failure(),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props =>
      [username, email, password, passwordRepeat, status, failure];

  SignupState copyWith({
    String username,
    String email,
    String password,
    String passwordRepeat,
    SignupStatus status,
    Failure failure,
  }) {
    return SignupState(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      passwordRepeat: passwordRepeat ?? this.passwordRepeat,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
