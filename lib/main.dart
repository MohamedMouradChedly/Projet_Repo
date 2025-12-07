import 'dart:io';
import 'package:demo/view/login_page.dart';
import 'package:demo/view/nav_page.dart';
import 'package:demo/viewmodel/course_view_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'viewmodel/auth_view_model.dart';
import 'viewmodel/nav_view_model.dart';
import 'firebase_options.dart';
import 'package:demo/services/paymee_service.dart'; // Paymee service import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // -----------------------------
  // Initialize Firebase BEFORE runApp
  // -----------------------------
  try {
    if (Platform.isAndroid) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyCAntoRgpsz_irnxrd-38ia2FCEXWKeWKw",
          appId: "1:977658916468:android:b4bc78b74fe45e24f6eb21",
          messagingSenderId: "977658916468",
          projectId: "demo1-5b291",
        ),
      );
    } else {
      await Firebase.initializeApp();
    }
    print("Firebase initialized successfully");
  } catch (e) {
    print("Firebase initialization failed: $e");
  }

  // -----------------------------
  // Run the app
  // -----------------------------
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => NavViewModel()),
        ChangeNotifierProvider(create: (_) => CourseViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Demo Android Firebase MVVM',
      theme: ThemeData(
        primaryColor: const Color(0xFF7F7CFF),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF7F7CFF),
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFA77BFF),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

// -----------------------------
// SPLASH SCREEN
// -----------------------------
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Animation for logo scaling
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Navigate to login page after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF7F7CFF),
              Color(0xFFA77BFF),
              Color(0xFFD77BFF),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: ScaleTransition(
            scale: _animation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/logo/9a9a.png',
                  width: 120,
                  height: 120,
                ),
                const SizedBox(height: 10),
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
