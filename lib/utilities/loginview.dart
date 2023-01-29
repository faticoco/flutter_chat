import 'package:flutter/material.dart';
import 'package:flutter_chat/constants/routes.dart';
import 'package:flutter_chat/services/auth/auth_exceptions.dart';
import 'package:flutter_chat/services/auth/auth_service.dart';
import 'package:flutter_chat/utilities/showerrordialogs.dart';
import 'dart:developer' as devtools show log;

class Loginview extends StatefulWidget {
  const Loginview({super.key});

  @override
  State<Loginview> createState() => _LoginviewState();
}

class _LoginviewState extends State<Loginview> {
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
    return Container(
      child: Material(
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
                bool login = true;
                try {
                  await authservice.firebase().logIn(
                        email: email,
                        password: password,
                      );
                  final user = authservice.firebase().currentuser;
                  if (user?.isEmailVerified ?? false) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      notesRoute,
                      (route) => false,
                    );
                  } else {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      verifyemailroute,
                      (route) => false,
                    );
                  }
                } on userNotFoundAuthException {
                  login = false;
                  await showErrorDialog(
                    context,
                    'user not found',
                  );
                } on WrongPasswordAuthException {
                  login = false;
                  await showErrorDialog(
                    context,
                    'wrong password',
                  );
                } on GenericAuthException {
                  await showErrorDialog(
                    context,
                    'authentication error',
                  );
                }
                if (login) {
                  devtools.log("LOGGED IN ");
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    notesRoute,
                    (route) => false,
                  );
                }
              },
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  registerroute,
                  (route) => false,
                );
              },
              child: const Text('Not registered yet? Register here!'),
            )
          ],
        ),
      ),
    );
  }
}
