import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/auth_view_model.dart';
import 'change_password_page.dart';
import 'edit_profile_page.dart';
import 'login_page.dart';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatelessWidget {
  final String userEmail;
  final String userName;

  const ProfilePage({
    super.key,
    required this.userEmail,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context, listen: false);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff7F7CFF), Color(0xffA77BFF), Color(0xffD77BFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                      child: Column(
                        children: [
                          /// ----------- PROFILE PICTURE -----------
                          FutureBuilder<DocumentSnapshot?>(
                            future: authVM.user != null
                                ? FirebaseFirestore.instance
                                .collection('users')
                                .doc(authVM.user!.uid)
                                .get()
                                : Future.value(null),
                            builder: (context, snapshot) {
                              final data = snapshot.data?.data() as Map<String, dynamic>?;
                              String profilePath = data?['profileImage'] ?? '';

                              ImageProvider imageProvider;
                              if (profilePath.isNotEmpty) {
                                imageProvider = profilePath.startsWith('http')
                                    ? NetworkImage(profilePath)
                                    : AssetImage(profilePath) as ImageProvider;
                              } else {
                                imageProvider = const AssetImage("assets/imageP/default.png");
                              }

                              return Center(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: 130,
                                      height: 130,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.15),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.white.withOpacity(0.3), width: 2),
                                      ),
                                    ),
                                    CircleAvatar(
                                      radius: 55,
                                      backgroundColor: Colors.grey.shade300,
                                      backgroundImage: imageProvider,
                                      child: profilePath.isEmpty
                                          ? const Icon(Icons.person,
                                          size: 60, color: Colors.white)
                                          : null,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 20),

                          /// ----------- NAME + EMAIL -----------
                          Text(
                            userName,
                            style: const TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            userEmail,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xffFFD66B),
                            ),
                          ),

                          const SizedBox(height: 25),

                          /// ----------- EDIT BUTTON -----------
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EditProfilePage(
                                    email: userEmail,
                                    currentName: userName,
                                    currentEmail: userEmail,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 20),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.white.withOpacity(0.3)),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4)),
                                ],
                              ),
                              child: const Center(
                                child: Text(
                                  "Modifier le profil",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),

                          /// ----------- SETTINGS MENU -----------
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                                ),
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: const Icon(Icons.lock, color: Colors.white),
                                      title: const Text(
                                        "Changer le mot de passe",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                ChangePasswordPage(userEmail: userEmail),
                                          ),
                                        );
                                      },
                                    ),
                                    const Divider(color: Colors.white24, height: 1),
                                    ListTile(
                                      leading: const Icon(Icons.logout, color: Colors.red),
                                      title: const Text(
                                        "Déconnexion",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      onTap: () async {
                                        await authVM.logout();
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => const LoginPage()),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),
                          // This ensures the column fills remaining space and avoids white bottom
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
