import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:jugruppe/auth/authentication_service.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatelessWidget {
  static const routeName = '/signup';

  final _formKey = GlobalKey<FormState>();

  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _passwordRepeatFocusNode = FocusNode();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordRepeatController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: emailController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  labelText: "E-Mail",
                ),
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
              TextFormField(
                controller: passwordController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Passwort",
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                focusNode: _passwordFocusNode,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a password.';
                  }
                  if (value.toString().length < 8) {
                    return 'Please enter a password greater than 8 digits.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: passwordRepeatController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Passwort wiederholen",
                ),
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                focusNode: _passwordRepeatFocusNode,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a password.';
                  }
                  if (value.toString().length < 8) {
                    return 'Please enter a password greater than 7 digits.';
                  }
                  if (passwordController.text !=
                      passwordRepeatController.text) {
                    return 'Please enter a the same password.';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  signUp(context);
                },
                child: Text("Registrieren"),
              )
            ],
          ),
        ),
      ),
    );
  }

  void signUp(BuildContext context) {
    final isValid = _formKey.currentState.validate();

    if (isValid) {
      context
          .read<AuthenticationService>()
          .signUp(
            email: emailController.text.trim(),
            password: passwordController.text,
          )
          .then((value) => (_) {
                Navigator.of(context).pop();
              })
          .onError((error, stackTrace) => (err) {
                print(err);
              });
    }
  }
}
