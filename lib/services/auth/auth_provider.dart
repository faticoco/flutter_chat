import 'package:flutter_chat/services/auth/auth_user.dart';

abstract class Authprovider {
  Authuser? get currentuser;
  Future<Authuser> logIn({
    required String email,
    required String password,
  });

  Future<Authuser> createuser({
    required String email,
    required String password,
  });

  Future<void> Logout();
  Future<void> sendEmailVerification();
}
