// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDspABZGHRlq754IC4meX2Vd7WG5cgCobw',
    appId: '1:58231164875:web:d2ef63175ddfa35a49704e',
    messagingSenderId: '58231164875',
    projectId: 'faticoco-chat-proj',
    authDomain: 'faticoco-chat-proj.firebaseapp.com',
    storageBucket: 'faticoco-chat-proj.appspot.com',
    measurementId: 'G-D8HWSYGTJQ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC8CkW326o9TiVwCJRD1Rd2A43DBInv9nA',
    appId: '1:58231164875:android:cb4a7079c6c4c26649704e',
    messagingSenderId: '58231164875',
    projectId: 'faticoco-chat-proj',
    storageBucket: 'faticoco-chat-proj.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDWcSpp4Om2K8zr8gd_bieaSvilvZ6ytJ4',
    appId: '1:58231164875:ios:90778634d8bb9af349704e',
    messagingSenderId: '58231164875',
    projectId: 'faticoco-chat-proj',
    storageBucket: 'faticoco-chat-proj.appspot.com',
    iosClientId: '58231164875-fbto6ilos2jjrf4gkks65o4hshjprq54.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterChat',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDWcSpp4Om2K8zr8gd_bieaSvilvZ6ytJ4',
    appId: '1:58231164875:ios:90778634d8bb9af349704e',
    messagingSenderId: '58231164875',
    projectId: 'faticoco-chat-proj',
    storageBucket: 'faticoco-chat-proj.appspot.com',
    iosClientId: '58231164875-fbto6ilos2jjrf4gkks65o4hshjprq54.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterChat',
  );
}
