import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view/home_page.dart';
import '../view/search_page.dart';
import '../view/cart_page.dart';
import '../view/profile_page.dart';
import '../viewmodel/auth_view_model.dart';

class NavPage extends StatefulWidget {
  const NavPage({super.key});

  @override
  State<NavPage> createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  int currentIndex = 0;

  List<Widget> getPages(String email, String name, String profileImage) {
    return [
      HomePage(userEmail: email, profileImage: profileImage), // keep for HomePage
      const SearchPage(),
      const CartPage(),
      ProfilePage(userEmail: email, userName: name), // removed profileImage
    ];
  }


  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthViewModel>(context, listen: false);
    final String email = auth.currentUserEmail;
    final String name = auth.currentUserName;
    final String profileImage = auth.currentUserProfileImage; // Added profileImage

    return Scaffold(
      extendBody: true, // allows navbar to float above background
      body: getPages(email, name, profileImage)[currentIndex],

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: BottomNavigationBar(
                currentIndex: currentIndex,
                backgroundColor: Colors.transparent,
                elevation: 0,
                selectedItemColor: Colors.deepPurpleAccent,
                unselectedItemColor: Colors.white70,
                showSelectedLabels: true,
                showUnselectedLabels: false,
                type: BottomNavigationBarType.fixed,
                onTap: (index) {
                  setState(() => currentIndex = index);
                },
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_rounded),
                    label: "Home",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.search_rounded),
                    label: "Search",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.payments_rounded), // UPDATED ICON
                    label: "Purchase", // UPDATED NAME
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person_rounded),
                    label: "Profile",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
