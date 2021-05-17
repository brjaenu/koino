import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jugruppe/repositories/auth/auth_repository.dart';
import 'package:jugruppe/screens/signup/cubit/signup_cubit.dart';
import 'package:jugruppe/widgets/widgets.dart';

class SignupScreen extends StatelessWidget {
  static const String routeName = '/signup';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<SignupCubit>(
        create: (_) =>
            SignupCubit(authRepository: context.read<AuthRepository>()),
        child: SignupScreen(),
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();
  final _usernameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _passwordRepeatFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocConsumer<SignupCubit, SignupState>(
          listener: (context, state) {
            if (state.status == SignupStatus.error) {
              showDialog(
                context: context,
                builder: (context) =>
                    ErrorDialog(content: state.failure.message),
              );
            }
          },
          builder: (context, state) {
            return Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: ListView(
                    children: [
                      Card(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'JuGruppe',
                                  style: TextStyle(
                                    fontSize: 28.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 12.0),
                                TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  decoration:
                                      InputDecoration(hintText: 'Username'),
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.name,
                                  focusNode: _usernameFocusNode,
                                  onChanged: (value) => context
                                      .read<SignupCubit>()
                                      .usernameChanged(value),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter a username.';
                                    }
                                    if (value.toString().length < 4) {
                                      return 'Please enter a username greater than 3 characters.';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 12.0),
                                TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  decoration:
                                      InputDecoration(hintText: 'E-Mail'),
                                  onChanged: (value) => context
                                      .read<SignupCubit>()
                                      .emailChanged(value),
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.emailAddress,
                                  focusNode: _emailFocusNode,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter a email.';
                                    }
                                    if (!EmailValidator.validate(value)) {
                                      return 'Please enter a valid email';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 12.0),
                                TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  obscureText: true,
                                  decoration:
                                      InputDecoration(hintText: 'Password'),
                                  onChanged: (value) => context
                                      .read<SignupCubit>()
                                      .passwordChanged(value),
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.text,
                                  focusNode: _passwordFocusNode,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter a password.';
                                    }
                                    if (value.toString().length < 8) {
                                      return 'Please enter a password greater than 8 characters.';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 12.0),
                                TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      hintText: 'Repeat password'),
                                  onChanged: (value) => context
                                      .read<SignupCubit>()
                                      .passwordRepeatChanged(value),
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.text,
                                  focusNode: _passwordRepeatFocusNode,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please repeat the password.';
                                    }
                                    if (value.toString().length < 8) {
                                      return 'Please enter a password greater than 8 characters.';
                                    }
                                    if (value.toString() !=
                                        context
                                            .read<SignupCubit>()
                                            .state
                                            .password) {
                                      return 'Please enter the same password.';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 28.0),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 1.0,
                                    primary: Theme.of(context).primaryColor,
                                    onPrimary: Colors.white,
                                  ),
                                  onPressed: () => _submitForm(context,
                                      state.status == SignupStatus.submitting),
                                  child: Text('Sign Up'),
                                ),
                                const SizedBox(height: 12.0),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 1.0,
                                      primary: Colors.grey[200],
                                      onPrimary: Colors.black),
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text('Already an account? Login'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  _submitForm(BuildContext context, bool isSubmnitting) {
    if (_formKey.currentState.validate() && !isSubmnitting) {
      context.read<SignupCubit>().signUpWithCredentials();
    }
  }
}
