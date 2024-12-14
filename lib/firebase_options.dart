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
    apiKey: 'AIzaSyACVAicnbz_apUJW4GJihxqgVE1pc4z2zs',
    appId: '1:650487245806:web:02b76fdcd01f560bfabcff',
    messagingSenderId: '650487245806',
    projectId: 'vegetableshop-479d4',
    authDomain: 'vegetableshop-479d4.firebaseapp.com',
    storageBucket: 'vegetableshop-479d4.firebasestorage.app',
    measurementId: 'G-7BT56XDB0K',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCHd4Hn-jEkjH9Y5RblMmwg92H2KyLVBFY',
    appId: '1:650487245806:android:cb4aca03a578869bfabcff',
    messagingSenderId: '650487245806',
    projectId: 'vegetableshop-479d4',
    storageBucket: 'vegetableshop-479d4.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAdKKPOt8AHsFrBAvXGIg8OA0Z1Y0EIFOY',
    appId: '1:650487245806:ios:889ecafc88054a90fabcff',
    messagingSenderId: '650487245806',
    projectId: 'vegetableshop-479d4',
    storageBucket: 'vegetableshop-479d4.firebasestorage.app',
    androidClientId:
        '650487245806-5f8n11uu9pik9tdvoi8ca5250gg1281f.apps.googleusercontent.com',
    iosClientId:
        '650487245806-c4dkqckn309kcepclcle3tlr9ahk1ntg.apps.googleusercontent.com',
    iosBundleId: 'com.toqse.ecomapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAdKKPOt8AHsFrBAvXGIg8OA0Z1Y0EIFOY',
    appId: '1:650487245806:ios:38e78107ff9c0379fabcff',
    messagingSenderId: '650487245806',
    projectId: 'vegetableshop-479d4',
    storageBucket: 'vegetableshop-479d4.firebasestorage.app',
    androidClientId:
        '650487245806-5f8n11uu9pik9tdvoi8ca5250gg1281f.apps.googleusercontent.com',
    iosClientId:
        '650487245806-357v1gubp7emv5pprbeldokdphks8gih.apps.googleusercontent.com',
    iosBundleId: 'com.example.ecomApp2',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyACVAicnbz_apUJW4GJihxqgVE1pc4z2zs',
    appId: '1:650487245806:web:170b97cd86a24a34fabcff',
    messagingSenderId: '650487245806',
    projectId: 'vegetableshop-479d4',
    authDomain: 'vegetableshop-479d4.firebaseapp.com',
    storageBucket: 'vegetableshop-479d4.firebasestorage.app',
    measurementId: 'G-673BXPSPJJ',
  );
}
