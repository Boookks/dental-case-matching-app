// File generated manually for the current Firebase project setup.
// It mirrors the values from android/app/google-services.json.

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions are not configured for web.',
      );
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
        throw UnsupportedError(
          'DefaultFirebaseOptions are only configured for Android right now.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBWcFehHxOxGENfYEd0xlFNtGxDTngMPQ0',
    appId: '1:835907354613:android:23cf48594eb63b561a2abc',
    messagingSenderId: '835907354613',
    projectId: 'dental-case-matching-app',
    storageBucket: 'dental-case-matching-app.firebasestorage.app',
  );
}
