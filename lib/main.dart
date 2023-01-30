import 'package:flutter/material.dart';
import 'package:flutter_chat/utilities/views/notes/new_notes_view.dart';
import '/constants/routes.dart';
import '/utilities/loginview.dart';
import '/utilities/register_view.dart';
import '/services/auth/auth_service.dart';
import '/utilities/views/notesview.dart';
import '/utilities/views/verifyemailview.dart';
import 'firebase_options.dart';
import 'dart:developer' as devtools show log;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Homepage(),
      routes: {
        loginRoute: (context) => const Loginview(),
        registerroute: (context) => const RegisterView(),
        notesRoute: (context) => const view(),
        verifyemailroute: (context) => const Verifyemailview(),
        newnoteroute: (context) => const newNoteView(),
      },
    ),
  );
}

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: authservice.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = authservice.firebase().currentuser;

            if (user != null) {
              if (user.isEmailVerified) {
                devtools.log('email verified');
                return const view();
              } else {
                return const Verifyemailview();
              }
            } else {
              return const Loginview();
            }

          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
