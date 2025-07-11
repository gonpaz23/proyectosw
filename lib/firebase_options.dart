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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBWS7swNB8nQg_CcwOcNfXxwBgcNpHq5ik',
    appId: '1:648071057535:web:7e469572f1a510d6c26f4a',
    messagingSenderId: '648071057535',
    projectId: 'proyectoswapi2806',
    authDomain: 'proyectoswapi2806.firebaseapp.com',
    databaseURL: 'https://proyectoswapi2806-default-rtdb.firebaseio.com',
    storageBucket: 'proyectoswapi2806.firebasestorage.app',
    measurementId: 'G-BBK02LYC5C',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBlslyp-TuC8XcRniwD1_sE4a6LJ3AKagw',
    appId: '1:648071057535:android:f1475615f2b8d0dbc26f4a',
    messagingSenderId: '648071057535',
    projectId: 'proyectoswapi2806',
    databaseURL: 'https://proyectoswapi2806-default-rtdb.firebaseio.com',
    storageBucket: 'proyectoswapi2806.firebasestorage.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBWS7swNB8nQg_CcwOcNfXxwBgcNpHq5ik',
    appId: '1:648071057535:web:8477653e39ba9f29c26f4a',
    messagingSenderId: '648071057535',
    projectId: 'proyectoswapi2806',
    authDomain: 'proyectoswapi2806.firebaseapp.com',
    databaseURL: 'https://proyectoswapi2806-default-rtdb.firebaseio.com',
    storageBucket: 'proyectoswapi2806.firebasestorage.app',
    measurementId: 'G-4WF0Q2HQ3C',
  );
}
