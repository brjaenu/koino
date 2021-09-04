import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:koino/repositories/auth/auth_repository.dart';
import 'package:koino/screens/signup/cubit/signup_cubit.dart';
import 'package:koino/widgets/widgets.dart';

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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BlocConsumer<SignupCubit, SignupState>(
        listener: (context, state) {
          if (state.status == SignupStatus.error) {
            showDialog(
              context: context,
              builder: (context) => ErrorDialog(content: state.failure.message),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text('REGISTRIEREN'),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 50.0),
                          Text(
                            'Erstelle einen neuen Account',
                            style: Theme.of(context).textTheme.headline4,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 25.0),
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              hintText: 'BENUTZERNAME',
                              prefixIcon: Icon(
                                FontAwesomeIcons.solidUser,
                                color: Theme.of(context).iconTheme.color,
                                size: 20.0,
                              ),
                            ),
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
                          const SizedBox(height: 25.0),
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              hintText: 'EMAIL',
                              prefixIcon: Icon(
                                FontAwesomeIcons.solidEnvelope,
                                color: Theme.of(context).iconTheme.color,
                                size: 20.0,
                              ),
                            ),
                            onChanged: (value) =>
                                context.read<SignupCubit>().emailChanged(value),
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
                          const SizedBox(height: 25.0),
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'PASSWORT',
                              prefixIcon: Icon(
                                FontAwesomeIcons.lock,
                                color: Theme.of(context).iconTheme.color,
                                size: 20.0,
                              ),
                            ),
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
                          const SizedBox(height: 25.0),
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'PASSWORT WIEDERHOLEN',
                              prefixIcon: Icon(
                                FontAwesomeIcons.lock,
                                color: Theme.of(context).iconTheme.color,
                                size: 20.0,
                              ),
                            ),
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
                                  context.read<SignupCubit>().state.password) {
                                return 'Please enter the same password.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 25.0),
                          ElevatedButton(
                            onPressed: () => _submitForm(context,
                                state.status == SignupStatus.submitting),
                            child: Text('REGISTRIEREN'),
                          ),
                          const SizedBox(height: 25.0),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                                'Hast du bereits einen Account? Jetzt anmelden.'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  _submitForm(BuildContext context, bool isSubmnitting) {
    if (_formKey.currentState.validate() && !isSubmnitting) {
      context.read<SignupCubit>().signUpWithCredentials();
    }
  }
}
