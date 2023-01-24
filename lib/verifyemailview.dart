import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
          const Text('Please verify your email address:'),
          TextButton(
            onPressed: () async {
              print('email verification sent , check mail!');
              final user = FirebaseAuth.instance.currentUser;
              await user?.sendEmailVerification();
            },
            child: const Text('send email verification'),
          )
        ],
      ),
    );
  }
}
