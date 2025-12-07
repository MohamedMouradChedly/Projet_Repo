import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> sendMessage(String userId, String messageText, String role) async {
  await FirebaseFirestore.instance
      .collection("users")
      .doc(userId)
      .collection("messages")
      .add({
    "text": messageText,
    "role": role, // "user" or "admin"
    "timestamp": FieldValue.serverTimestamp(),
  });
}
