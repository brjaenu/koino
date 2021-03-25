import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:jugruppe/auth/authentication_service.dart';
import 'package:jugruppe/auth/signup_page.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                focusNode: _passwordFocusNode,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a password.';
                  }
                  if (value.toString().length < 8) {
                    return 'Please enter a password greater than 7 digits.';
                  }
                  return null;
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        singIn(context);
                      },
                      child: Text("Einloggen"),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed(SignUpPage.routeName);
                      },
                      child: Text("Registrieren"),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void singIn(BuildContext context) {
    context.read<AuthenticationService>().signIn(
          email: emailController.text.trim(),
          password: passwordController.text,
        );
  }
}
