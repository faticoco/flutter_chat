import 'package:flutter/material.dart';
import 'package:flutter_chat/constants/routes.dart';
import 'package:flutter_chat/services/auth/auth_exceptions.dart';
import 'package:flutter_chat/services/auth/auth_service.dart';
import 'package:flutter_chat/utilities/showerrordialogs.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Enter email',
            ),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: 'Enter Password',
            ),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await authservice.firebase().createuser(
                      email: email,
                      password: password,
                    );

                authservice.firebase().sendEmailVerification();
                Navigator.of(context).pushNamed(verifyemailroute);
              } on WeakPasswordAuthException {
                await showErrorDialog(
                  context,
                  'this is a weak password',
                );
              } on EmailAlreadyInUseAuthException {
                await showErrorDialog(
                  context,
                  'this is an email address already in use',
                );
              } on InvalidEmailAuthException {
                await showErrorDialog(
                  context,
                  'this is an invalid email address',
                );
              } on GenericAuthException {
                await showErrorDialog(
                  context,
                  'failed to register',
                );
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginRoute, (route) => false);
            },
            child: const Text('Already registered? Login here!'),
          )
        ],
      ),
    );
  }
}
