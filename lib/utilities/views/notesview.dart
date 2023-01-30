import 'package:flutter/material.dart';
import 'package:flutter_chat/constants/routes.dart';
import 'package:flutter_chat/services/auth/auth_service.dart';
import 'package:flutter_chat/enums/menu_actions.dart';
import 'package:flutter_chat/services/crud/notes_serive.dart';

class view extends StatefulWidget {
  const view({super.key});

  @override
  State<view> createState() => _viewState();
}

class _viewState extends State<view> {
  late final notesService _noteservice;
  String get Useremail => authservice.firebase().currentuser!.email!;

  @override
  void initState() {
    _noteservice = notesService();
    super.initState();
  }

  @override
  void dispose() {
    _noteservice.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(newnoteroute);
              },
              icon: const Icon(Icons.add)),
          PopupMenuButton<menuaction>(
            onSelected: (value) async {
              switch (value) {
                case menuaction.logout:
                  final logout_ = await showLogoutDialogbox(context);
                  if (logout_) {
                    await authservice.firebase().Logout();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(loginRoute, (_) => false);
                  }
                  break;
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem(
                  value: menuaction.logout,
                  child: Text('logout'),
                ),
              ];
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: _noteservice.getorcreateuser(email: Useremail),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder(
                stream: _noteservice.allnotes,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      return const Text('waiting for all notes');
                    default:
                      return const CircularProgressIndicator();
                  }
                },
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

//building dialog box

Future<bool> showLogoutDialogbox(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Sign out'),
        content: const Text('Are you sure you want to log out'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel')),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Log out')),
        ],
      );
    },
  ).then((value) => value ?? false);
}
