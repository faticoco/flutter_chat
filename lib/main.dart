import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/loginview.dart';
import 'package:flutter_chat/register_view.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Homepage(),
      routes: {
        '/login/': (context) => const Loginview(),
        '/register/': (context) => const RegisterView(),
      },
    ),
  );
}

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              //final user = FirebaseAuth.instance.currentUser;
              //if (user?.emailVerified ?? false) {
              //} else {
              //Navigator.of(context).push(
              // MaterialPageRoute(
              // builder: (context) => const Verifyemailview(),
              //),
              //);
              //}
              return const Loginview();
            default:
              return const Text('........Loading');
          }
        },
      ),
    );
  }
}

class Verifyemailview extends StatefulWidget {
  const Verifyemailview({super.key});

  @override
  State<Verifyemailview> createState() => _VerifyemailviewState();
}

class _VerifyemailviewState extends State<Verifyemailview> {
  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}
