import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCAntoRgpsz_irnxrd-38ia2FCEXWKeWKw',             // Remplace par ta vraie API Key
    appId: '1:977658916468:android:b4bc78b74fe45e24f6eb21',              // Remplace par ton App ID Android
    messagingSenderId: '977658916468', // Remplace par ton Messaging Sender ID
    projectId: 'demo1-5b291',              // Remplace par ton Project ID
    storageBucket: 'demo1-5b291.appspot.com',  // Remplace par ton Storage Bucket
  );
}
