import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/auth_view_model.dart';
import '../viewmodel/course_view_model.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'nav_page.dart';
import '../models/course_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  String selectedProfileImage = "assets/imageP/default.png"; // default profile image

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context, listen: false);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Créer un compte"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff7F7CFF), Color(0xffA77BFF), Color(0xffD77BFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 40),

                // --- Profile Image Selector ---
                GestureDetector(
                  onTap: () {
                    List<String> images = [
                      "assets/imageP/profil1.jpg",
                      "assets/imageP/profil2.jpg",
                      "assets/imageP/profil3.jpg",
                      "assets/imageP/default.jpg",
                      "assets/imageP/profil4.jpg",
                      "assets/imageP/profil5.jpg",
                      "assets/imageP/profil6.jpg",
                      "assets/imageP/profil7.jpg",
                      "assets/imageP/profil8.jpg",
                      "assets/imageP/profil9.jpg",
                      "assets/imageP/profil10.jpg",
                      "assets/imageP/profil11.jpg",
                      "assets/imageP/profil12.jpg",
                      "assets/imageP/profil13.jpg",
                      "assets/imageP/profil14.jpg",
                      "assets/imageP/profil15.jpg",
                      "assets/imageP/profil16.jpg",
                      "assets/imageP/profil17.jpg",
                      "assets/imageP/profil18.jpg",
                      "assets/imageP/profil19.jpg",
                      "assets/imageP/profil20.jpg",


                    ];
                    int currentIndex = images.indexOf(selectedProfileImage);
                    int nextIndex = (currentIndex + 1) % images.length;
                    setState(() {
                      selectedProfileImage = images[nextIndex];
                    });
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(selectedProfileImage),
                    backgroundColor: Colors.white.withOpacity(0.25),
                  ),
                ),
                const SizedBox(height: 20),

                // --- Form Card ---
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12.withOpacity(0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        "Inscription",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // --- Name ---
                      TextField(
                        controller: nameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Nom complet",
                          hintStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.25),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 16),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // --- Email ---
                      TextField(
                        controller: emailController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Adresse email",
                          hintStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.25),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 16),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // --- Password ---
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Mot de passe",
                          hintStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.25),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 16),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // --- Confirm Password ---
                      TextField(
                        controller: confirmPasswordController,
                        obscureText: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Confirmer le mot de passe",
                          hintStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.25),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 16),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // --- Sign Up Button ---
                      SizedBox(
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffFFD66B),
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          onPressed: () async {
                            final name = nameController.text.trim();
                            final email = emailController.text.trim();
                            final password = passwordController.text.trim();
                            final confirmPassword =
                            confirmPasswordController.text.trim();

                            if (password != confirmPassword) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Les mots de passe ne correspondent pas.")),
                              );
                              return;
                            }

                            try {
                              // ✅ Pass profileImage here
                              await authVM.signUp(
                                name,
                                email,
                                password,
                                profileImage: selectedProfileImage,
                              );

                              // Fetch courses from Firestore
                              final allCourses = await FirebaseFirestore.instance
                                  .collection('courses')
                                  .get()
                                  .then((snapshot) => snapshot.docs
                                  .map((doc) =>
                                  Course.fromMap(doc.data(), doc.id))
                                  .toList());

                              // Initialize cart
                              final courseVM =
                              Provider.of<CourseViewModel>(context, listen: false);
                              courseVM.initializeCartForNewUser(allCourses,
                                  itemCount: 3);
                              // Navigate to main page
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const NavPage()));

                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())));
                            }
                          },
                          child: const Text(
                            "Créer un compte",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // --- Login Redirect ---
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const LoginPage()),
                            );
                          },
                          child: const Text(
                            "Déjà un compte ? Se connecter",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
