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
    apiKey: 'AIzaSyBamu-s-2Vs2Wfi65BFzWREU65tm1j6GPg',
    appId: '1:130333578524:web:86c4a6b000bf3ca71c56d9',
    messagingSenderId: '130333578524',
    projectId: 'groverzmart-31334',
    authDomain: 'groverzmart-31334.firebaseapp.com',
    storageBucket: 'groverzmart-31334.appspot.com',
    measurementId: 'G-FYNMNJRFCJ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD6wgOjIolbE8AjrS2S2y1UrdCmXApXoIk',
    appId: '1:130333578524:android:ba37e9b7453b2a461c56d9',
    messagingSenderId: '130333578524',
    projectId: 'groverzmart-31334',
    storageBucket: 'groverzmart-31334.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC2RsRLxKeroRMEQnwREHvUbV76tTY9uR0',
    appId: '1:130333578524:ios:1bab556116c80f221c56d9',
    messagingSenderId: '130333578524',
    projectId: 'groverzmart-31334',
    storageBucket: 'groverzmart-31334.appspot.com',
    iosBundleId: 'com.example.gvz',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC2RsRLxKeroRMEQnwREHvUbV76tTY9uR0',
    appId: '1:130333578524:ios:1bab556116c80f221c56d9',
    messagingSenderId: '130333578524',
    projectId: 'groverzmart-31334',
    storageBucket: 'groverzmart-31334.appspot.com',
    iosBundleId: 'com.example.gvz',
  );
}
