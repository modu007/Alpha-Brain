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
    androidClientId: '529956110580-70p7ssq8bq3ors43fga7kkkt0bpk6ifp.apps.googleusercontent.com',
    iosClientId: '529956110580-ml4e5dhdvt1ue9q31m3br0d9o3kclfbs.apps.googleusercontent.com',
    iosBundleId: 'com.example.neuralcode',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBKZpg_v5IapKOwZkkQ2dOeoJ0B5uQNgqg',
    appId: '1:529956110580:ios:828d21fbf68683b8c81ea1',
    messagingSenderId: '529956110580',
    projectId: 'z-alpha-brains',
    storageBucket: 'z-alpha-brains.appspot.com',
    androidClientId: '529956110580-70p7ssq8bq3ors43fga7kkkt0bpk6ifp.apps.googleusercontent.com',
    iosClientId: '529956110580-ml4e5dhdvt1ue9q31m3br0d9o3kclfbs.apps.googleusercontent.com',
    iosBundleId: 'com.example.neuralcode',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA9nWum8jzjd7P59O2m5MUQJUjwI6PsVW8',
    appId: '1:529956110580:web:0d36025f103fed7ac81ea1',
    messagingSenderId: '529956110580',
    projectId: 'z-alpha-brains',
    authDomain: 'z-alpha-brains.firebaseapp.com',
    storageBucket: 'z-alpha-brains.appspot.com',
  );
}
