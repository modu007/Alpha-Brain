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
    apiKey: 'AIzaSyBOHViD_3z7s2xYt9YI0CXqOXWGIY8tmQA',
    appId: '1:529956110580:web:f6b771ecb23071f3c81ea1',
    messagingSenderId: '529956110580',
    projectId: 'z-alpha-brains',
    authDomain: 'z-alpha-brains.firebaseapp.com',
    storageBucket: 'z-alpha-brains.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB3CbM_b9wIDmxx0N3eOP-hVt1hcjqniKU',
    appId: '1:529956110580:android:f17f4ef49f2edb7fc81ea1',
    messagingSenderId: '529956110580',
    projectId: 'z-alpha-brains',
    storageBucket: 'z-alpha-brains.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBKZpg_v5IapKOwZkkQ2dOeoJ0B5uQNgqg',
    appId: '1:529956110580:ios:828d21fbf68683b8c81ea1',
    messagingSenderId: '529956110580',
    projectId: 'z-alpha-brains',
    storageBucket: 'z-alpha-brains.appspot.com',
    iosBundleId: 'com.example.neuralcode',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBKZpg_v5IapKOwZkkQ2dOeoJ0B5uQNgqg',
    appId: '1:529956110580:ios:035aa093ee8b915fc81ea1',
    messagingSenderId: '529956110580',
    projectId: 'z-alpha-brains',
    storageBucket: 'z-alpha-brains.appspot.com',
    iosBundleId: 'com.example.neuralcode.RunnerTests',
  );
}