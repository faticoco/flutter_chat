import 'package:flutter_chat/services/auth/auth_provider.dart';
import 'package:flutter_chat/services/auth/auth_user.dart';
import 'package:flutter_chat/services/auth/firebase_auth_provider.dart';

class authservice implements Authprovider {
  final Authprovider provider;
  const authservice(this.provider);

  factory authservice.firebase() => authservice(
        FirebaseAuthProvider(),
      );
  @override
  Future<void> Logout() => provider.Logout();

  @override
  Future<Authuser> createuser({
    required String email,
    required String password,
  }) =>
      provider.createuser(
        email: email,
        password: password,
      );

  @override
  Authuser? get currentuser => provider.currentuser;

  @override
  Future<Authuser> logIn({
    required String email,
    required String password,
  }) =>
      provider.logIn(
        email: email,
        password: password,
      );

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<void> initialize() => provider.initialize();
}
