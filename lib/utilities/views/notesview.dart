import 'package:flutter/material.dart';
import 'package:flutter_chat/services/auth/auth_service.dart';

import '../../enums/menu_actions.dart';
import '../../main.dart';

class view extends StatefulWidget {
  const view({super.key});

  @override
  State<view> createState() => _viewState();
}

class _viewState extends State<view> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main UI'),
        actions: [
          PopupMenuButton<menuaction>(
            onSelected: (value) async {
              switch (value) {
                case menuaction.logout:
                  final logout_ = await showLogoutDialogbox(context);
                  if (logout_) {
                    await authservice.firebase().Logout();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/login/', (_) => false);
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
      body: const Text('hello world'),
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
