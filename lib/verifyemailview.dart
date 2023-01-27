import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:flutter_chat/constants/routes.dart';

class Verifyemailview extends StatefulWidget {
  const Verifyemailview({super.key});

  @override
  State<Verifyemailview> createState() => _VerifyemailviewState();
}

class _VerifyemailviewState extends State<Verifyemailview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('verify email'),
      ),
      body: Column(
        children: [
          const Text("We've sent you an email verification. Please check!"),
          const Text(
              'If you havent recieved email verification, Please verify your email address by clicking the button below:'),
          TextButton(
            onPressed: () async {
              devtools.log('email verification sent , check mail!');
              final user = FirebaseAuth.instance.currentUser;
              await user?.sendEmailVerification();
            },
            child: const Text('send email verification'),
          ),
          TextButton(
            onPressed: () async {
              final user = FirebaseAuth.instance.signOut();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(registerroute, (route) => false);
            },
            child: const Text('Restart'),
          )
        ],
      ),
    );
  }
}
