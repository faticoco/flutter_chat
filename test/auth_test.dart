import 'package:flutter_chat/services/auth/auth_exceptions.dart';
import 'package:flutter_chat/services/auth/auth_provider.dart';
import 'package:flutter_chat/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group('mock aunthentication', () {
    final provider = MockAuthProvider();
    test('should not be initialized to begin with', () {
      expect(provider.isinitialized, false);
    });

    test('cannot logout if not initialized', () {
      expect(
        provider.Logout(),
        throwsA(const TypeMatcher<NotinitializedException>()),
      );
    });

    test('should be able to initialize', () async {
      await provider.initialize();
      expect(provider._isinitialized, true);
    });

    test('user should be null after initialization', () {
      expect(provider.currentuser, null);
    });

    test(
      'should be able to init in less than 2 seconds',
      () async {
        await provider.initialize();
        expect(provider.isinitialized, true);
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );

    test('create user should delegate to log in function', () async {
      final badEmailuser = provider.createuser(
        email: 'foobae@.com',
        password: 'foobar',
      );
      expect(badEmailuser,
          throwsA(const TypeMatcher<userNotFoundAuthException>()));

      final badpassworduser = provider.createuser(
        email: 'someone@gamil.com',
        password: 'foobar',
      );

      expect(badpassworduser,
          throwsA(const TypeMatcher<WrongPasswordAuthException>()));

      // final user = provider.createuser(
      //  email: 'foo@.com',
      //    password: 'foobar',
      //  );
/////////////////
      // expect(provider.currentuser, user);
      // expect(user.isEmailVerified, false);
    });

    test('logged in user should be able to get verified', () {
      provider.sendEmailVerification();
      final user = provider.currentuser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test('logged in and log out again', () async {
      await provider.Logout();
      await provider.logIn(
        email: 'email',
        password: 'password',
      );
      final user = provider.currentuser;
      expect(user, isNotNull);
    });
  });
}

class NotinitializedException implements Exception {}

class MockAuthProvider implements Authprovider {
  Authuser? _user;
  var _isinitialized = false;
  bool get isinitialized => _isinitialized;

  @override
  Future<void> Logout() async {
    if (!isinitialized) throw NotinitializedException();
    if (_user == null) throw userNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<Authuser> createuser({
    required String email,
    required String password,
  }) async {
    if (!isinitialized) throw NotinitializedException();
    Future.delayed(const Duration(seconds: 1));
    return logIn(
      email: email,
      password: password,
    );
  }

  @override
  Authuser? get currentuser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isinitialized = true;
  }

  @override
  Future<Authuser> logIn({
    required String email,
    required String password,
  }) {
    if (!isinitialized) throw NotinitializedException();
    if (email == 'foobae@.com') throw userNotFoundAuthException();
    if (password == 'foobar') throw WrongPasswordAuthException();
    const user = Authuser(isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isinitialized) throw NotinitializedException();
    final user = _user;
    if (user == null) {
      throw userNotFoundAuthException();
    }
    const newUser = Authuser(isEmailVerified: true);
    _user = newUser;
  }
}
