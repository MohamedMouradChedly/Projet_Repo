import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'ChatDiscussionPage.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

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
        child: SafeArea(
          child: Column(
            children: [
              AppBar(
                title: const Text("Users Messages"),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection("users").snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final users = snapshot.data!.docs;

                    if (users.isEmpty) {
                      return const Center(
                        child: Text(
                          "No users have chatted yet.",
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final userData = users[index].data() as Map<String, dynamic>;
                        final uid = users[index].id;
                        final userName = userData['name'] ?? "Unknown";
                        final profileImage = userData['profileImage'];

                        // Determine image provider
                        ImageProvider imageProvider;
                        if (profileImage != null && profileImage.isNotEmpty) {
                          if (profileImage.startsWith("http")) {
                            imageProvider = NetworkImage(profileImage);
                          } else {
                            imageProvider = AssetImage(profileImage);
                          }
                        } else {
                          imageProvider = const AssetImage("assets/imageP/default.png");
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    radius: 24,
                                    backgroundColor: Colors.transparent, // <-- remove purple background
                                    backgroundImage: imageProvider,
                                  ),
                                  title: Text(
                                    userName,
                                    style: const TextStyle(
                                        color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: const Text(
                                    "Tap to view conversation",
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ChatDiscussionPage(userId: uid),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
