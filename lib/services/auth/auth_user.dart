import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/cupertino.dart';

@immutable
class Authuser {
  final bool isEmailVerified;
  const Authuser(this.isEmailVerified);

  factory Authuser.fromFirebase(User user) => Authuser(user.emailVerified);
} 
