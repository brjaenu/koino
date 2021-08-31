import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:koino/repositories/auth/auth_repository.dart';
import 'package:koino/screens/login/cubit/login_cubit.dart';
import 'package:koino/screens/screens.dart';
import 'package:koino/widgets/error_dialog.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = '/login';

  static Route route() {
    return PageRouteBuilder(
      settings: const RouteSettings(name: routeName),
      transitionDuration: const Duration(seconds: 0),
      pageBuilder: (context, _, __) => BlocProvider<LoginCubit>(
        create: (_) =>
            LoginCubit(authRepository: context.read<AuthRepository>()),
        child: LoginScreen(),
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state.status == LoginStatus.error) {
              showDialog(
                context: context,
                builder: (context) =>
                    ErrorDialog(content: state.failure.message),
              );
            }
          },
          builder: (context, state) {
            return Scaffold(
              body: SingleChildScrollView(
                child: Padding(
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
                          'WILLKOMMEN BEI KOINO',
                          style: Theme.of(context).textTheme.headline1,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 50.0),
                        Text(
                          'Melde dich an, um forzufahren',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        const SizedBox(height: 25.0),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            hintText: 'EMAIL',
                            prefixIcon: Icon(
                              FontAwesomeIcons.solidEnvelope,
                              color: Theme.of(context).iconTheme.color,
                              size: 20.0,
                            ),
                          ),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          focusNode: _emailFocusNode,
                          onChanged: (value) =>
                              context.read<LoginCubit>().emailChanged(value),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter a email.';
                            }
                            if (!EmailValidator.validate(value)) {
                              return 'Please enter a valid email.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 25.0),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'PASSWORT',
                            prefixIcon: Icon(
                              FontAwesomeIcons.lock,
                              color: Theme.of(context).iconTheme.color,
                              size: 20.0,
                            ),
                          ),
                          onChanged: (value) =>
                              context.read<LoginCubit>().passwordChanged(value),
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.text,
                          focusNode: _passwordFocusNode,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter a password.';
                            }
                            if (value.toString().length < 8) {
                              return 'Please enter a password greater than 7 characters.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 25.0),
                        ElevatedButton(
                          onPressed: () => _submitForm(
                              context, state.status == LoginStatus.submitting),
                          child: Text('ANMELDEN'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context)
                              .pushNamed(SignupScreen.routeName),
                          child: Text(
                              'Hast du noch kein Account? Jetzt registrieren.'),
                        ),
                        const SizedBox(height: 25.0),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  _submitForm(BuildContext context, bool isSubmitting) {
    if (_formKey.currentState.validate() && !isSubmitting) {
      context.read<LoginCubit>().logInWithCredentials();
    }
  }
}
