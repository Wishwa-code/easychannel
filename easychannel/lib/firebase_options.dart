// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyDwD6DsFMu4ZmDW_SaBwntnVyukPhtWvKE',
    appId: '1:98329555024:web:28fb7cb9f0b4ab16e7e155',
    messagingSenderId: '98329555024',
    projectId: 'easychanv1',
    authDomain: 'easychanv1.firebaseapp.com',
    storageBucket: 'easychanv1.appspot.com',
    measurementId: 'G-5N16ZBJ7ZP',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDFuvrG3mUmqnF8XHMw0pmey7v_c-k4feU',
    appId: '1:98329555024:android:2f977c6a9b98a46ae7e155',
    messagingSenderId: '98329555024',
    projectId: 'easychanv1',
    storageBucket: 'easychanv1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD6RWMLaa92x_FuJNMus63pEjjWjY0EjZU',
    appId: '1:98329555024:ios:359703044e4be36fe7e155',
    messagingSenderId: '98329555024',
    projectId: 'easychanv1',
    storageBucket: 'easychanv1.appspot.com',
    iosBundleId: 'com.example.easychannel',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD6RWMLaa92x_FuJNMus63pEjjWjY0EjZU',
    appId: '1:98329555024:ios:359703044e4be36fe7e155',
    messagingSenderId: '98329555024',
    projectId: 'easychanv1',
    storageBucket: 'easychanv1.appspot.com',
    iosBundleId: 'com.example.easychannel',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDwD6DsFMu4ZmDW_SaBwntnVyukPhtWvKE',
    appId: '1:98329555024:web:07c8c2dfdc012819e7e155',
    messagingSenderId: '98329555024',
    projectId: 'easychanv1',
    authDomain: 'easychanv1.firebaseapp.com',
    storageBucket: 'easychanv1.appspot.com',
    measurementId: 'G-L02NB2WM6E',
  );

}