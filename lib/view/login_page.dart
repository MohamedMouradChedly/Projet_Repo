import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/auth_view_model.dart';
import 'sign_up_page.dart';
import 'nav_page.dart';
import 'administrationpage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
    AnimationController(vsync: this, duration: const Duration(seconds: 4))
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------
  // GLASSMORPHIC BLOCK WARNING POPUP
  // ---------------------------------------------------------
  void showBlockedDialog(String message) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "blocked",
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.25),
                    width: 1.4,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.block, size: 55, color: Colors.redAccent),
                    const SizedBox(height: 18),
                    const Text(
                      "Compte bloqué",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffFFD66B),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 12,
                        ),
                      ),
                      child: const Text("OK",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: anim,
            curve: Curves.easeOutBack,
          ),
          child: FadeTransition(opacity: anim, child: child),
        );
      },
    );
  }

  // ---------------------------------------------------------
  // ANIMATED "9ARINI" TITLE LETTERS
  // ---------------------------------------------------------
  Widget _animatedLetter(String letter, int index) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        final double rotationX = sin(_controller.value * 2 * pi + index) * 0.3;
        final double rotationY = cos(_controller.value * 2 * pi + index) * 0.3;
        final double scale =
            1 + 0.2 * sin(_controller.value * 2 * pi + index);

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..rotateX(rotationX)
            ..rotateY(rotationY)
            ..scale(scale),
          child: Text(
            letter,
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                    color: Colors.blueAccent, blurRadius: 12, offset: Offset(3, 3))
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------
  // BUILD METHOD
  // ---------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context, listen: false);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff7F7CFF),
              Color(0xffA77BFF),
              Color(0xffD77BFF),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      '9arini'.length,
                          (i) => _animatedLetter('9arini'[i], i),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // ---------------------------------------------------------
                  // LOGIN CARD
                  // ---------------------------------------------------------
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Connexion',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 28),

                        TextField(
                          controller: emailController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Adresse email',
                            labelStyle: const TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.12),
                          ),
                        ),

                        const SizedBox(height: 16),

                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Mot de passe',
                            labelStyle: const TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.12),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ---------------------------------------------------------
                        // LOGIN BUTTON
                        // ---------------------------------------------------------
                        ElevatedButton(
                          onPressed: () async {
                            final email = emailController.text.trim();
                            final password = passwordController.text.trim();

                            // Admin login
                            if (authVM.isAdminLogin(email, password)) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => AdministrationPage()),
                              );
                              return;
                            }

                            try {
                              // Firebase login
                              await authVM.login(email, password);

                              // Fetch user data
                              final userDoc = await authVM.fetchCurrentUserData();

                              // Blocked user
                              if (userDoc?["isBlocked"] == true) {
                                final msg = userDoc?["blockedMessage"] ??
                                    "Votre compte est bloqué.";
                                showBlockedDialog(msg);
                                return;
                              }

                              // Success
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const NavPage()),
                              );
                            } catch (e) {
                              showBlockedDialog(e.toString());
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffFFD66B),
                            foregroundColor: Colors.black,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: const Text(
                            'Se connecter',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // SIGN UP LINK
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const SignUpPage()),
                              );
                            },
                            child: const Text(
                              "Créer un compte",
                              style: TextStyle(
                                  color: Colors.white,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
