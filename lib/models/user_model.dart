class UserModel {
  final String uid;
  final String name;
  final String email;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
  });

  // Convert Firestore document to UserModel
  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
    );
  }

  // Convert UserModel to map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
    };
  }
}
