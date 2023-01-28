import 'package:flutter/material.dart';
import 'package:flutter_chat/constants/routes.dart';
import 'package:flutter_chat/services/auth/auth_service.dart';

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
              await authservice.firebase().sendEmailVerification();
            },
            child: const Text('send email verification'),
          ),
          TextButton(
            onPressed: () async {
              await authservice.firebase().Logout();
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
