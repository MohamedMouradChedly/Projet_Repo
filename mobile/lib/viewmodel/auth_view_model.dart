import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;

  // ----------- WALLET BALANCE -----------
  double _walletBalance = 0.0;
  double get walletBalance => _walletBalance;

  User? get user => _user;
  String get currentUserEmail => _user?.email ?? '';
  String get currentUserName => _user?.displayName ?? '';

  AuthViewModel() {
    _user = _auth.currentUser;
    if (_user != null) {
      fetchUserBalance();
      fetchUserProfileImage();
    }
  }

  // ----------- PROFILE IMAGE -----------
  String _profileImage = '';
  String get currentUserProfileImage => _profileImage;

  Future<void> fetchUserProfileImage() async {
    if (_user == null) return;
    final doc = await _firestore.collection('users').doc(_user!.uid).get();
    _profileImage = doc.data()?['profileImage'] ?? '';
    notifyListeners();
  }

  Future<Map<String, dynamic>?> fetchCurrentUserData() async {
    if (_user == null) return null;
    final doc = await _firestore.collection('users').doc(_user!.uid).get();
    return doc.data();
  }

  // ----------- WALLET BALANCE FETCH -----------
  Future<void> fetchUserBalance() async {
    if (_user == null) return;

    final doc = await _firestore.collection('users').doc(_user!.uid).get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      _walletBalance = (data['balance'] as num?)?.toDouble() ?? 0.0;
    } else {
      _walletBalance = 0.0;
    }

    notifyListeners();
  }

  // ----------- PAYMENT LOGIC -----------
  bool pay(double amount) {
    if (_walletBalance >= amount) {
      _walletBalance -= amount;

      // Update Firestore wallet
      _firestore
          .collection('users')
          .doc(_user!.uid)
          .update({'balance': _walletBalance});

      notifyListeners();
      return true;
    }
    return false;
  }

  // ----------- SIGN UP -----------
  Future<void> signUp(
      String name,
      String email,
      String password, {
        required String profileImage, // Profile image required
      }) async {
    UserCredential credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    _user = credential.user;

    if (_user != null) {
      await _user!.updateDisplayName(name);
      await _user!.reload();
      _user = _auth.currentUser;

      await _firestore.collection('users').doc(_user!.uid).set({
        'name': name,
        'email': email,
        'profileImage': profileImage,
        'balance': 0.0,
        'blocked': false,
        'blockedUntil': null,
      });

      _walletBalance = 0.0;
      _profileImage = profileImage;
    }

    notifyListeners();
  }

  // ----------- LOGIN WITH BLOCK CHECK -----------
  Future<void> login(String email, String password) async {
    UserCredential credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    _user = credential.user;
    if (_user == null) return;

    // Fetch user document
    final doc = await _firestore.collection('users').doc(_user!.uid).get();
    final data = doc.data();

    if (data != null) {
      final blocked = data['blocked'] ?? false;
      final blockedUntilMillis = data['blockedUntil'] as int?;
      final now = DateTime.now();

      if (blocked && blockedUntilMillis != null) {
        final blockedUntil =
        DateTime.fromMillisecondsSinceEpoch(blockedUntilMillis);
        if (now.isBefore(blockedUntil)) {
          // Logout immediately
          await _auth.signOut();
          _user = null;

          final remaining = blockedUntil.difference(now);
          throw Exception(
              "Votre compte est bloqué. Temps restant: ${formatDuration(remaining)}");
        } else {
          // Block expired
          await _firestore.collection('users').doc(_user!.uid).update({
            'blocked': false,
            'blockedUntil': null,
          });
        }
      }
    }

    await fetchUserBalance();
    await fetchUserProfileImage();

    notifyListeners();
  }

  String formatDuration(Duration d) {
    if (d.inMinutes < 60) return "${d.inMinutes} min";
    if (d.inHours < 24) return "${d.inHours} h ${d.inMinutes % 60} min";
    return "${d.inDays} j ${d.inHours % 24} h";
  }

  // ----------- LOGOUT -----------
  Future<void> logout() async {
    await _auth.signOut();
    _user = null;
    _walletBalance = 0.0;
    _profileImage = '';
    notifyListeners();
  }

  // ----------- ADMIN LOGIN CHECK -----------
  bool isAdminLogin(String email, String password) {
    const adminEmail = 'Admin@admin.tn';
    const adminPassword = '159753';
    return email == adminEmail && password == adminPassword;
  }

  // ----------- ADD TO WALLET -----------
  Future<void> addToWallet(double amount) async {
    if (_user == null) return;

    _walletBalance += amount;

    await _firestore
        .collection('users')
        .doc(_user!.uid)
        .update({'balance': _walletBalance});

    notifyListeners();
  }

  // ----------- ADMIN BLOCK USER -----------
  Future<void> blockUser(String uid, Duration duration) async {
    final blockedUntil =
        DateTime.now().add(duration).millisecondsSinceEpoch;

    await _firestore.collection('users').doc(uid).update({
      'blocked': true,
      'blockedUntil': blockedUntil,
    });
  }

  Future<void> unblockUser(String uid) async {
    await _firestore.collection('users').doc(uid).update({
      'blocked': false,
      'blockedUntil': null,
    });
  }
}
