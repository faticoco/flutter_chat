import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable
class Authuser {
  final String? email;
  final bool isEmailVerified;
  const Authuser({
    required this.isEmailVerified,
    required this.email,
  });

  factory Authuser.fromFirebase(User user) => Authuser(
        email: user.email,
        isEmailVerified: user.emailVerified,
      );
}
