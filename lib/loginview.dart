import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/constants/routes.dart';
import 'package:flutter_chat/register_view.dart';
import 'package:flutter_chat/utilities/showerrordialogs.dart';
import 'dart:developer' as devtools show log;

import 'main.dart';

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
                  final UserCredential = await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: email, password: password);
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    notesRoute,
                    (route) => false,
                  );
                } catch (e) {
                  print(e);
                  await showErrorDialog(
                    context,
                    'Error: ${e.toString()}',
                  );
                  login = false;
                }
                if (login) {
                  devtools.log("LOGGED IN ");
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
