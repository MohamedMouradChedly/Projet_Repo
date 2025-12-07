import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GestionUsersPage extends StatelessWidget {
  const GestionUsersPage({super.key});

  // --- Function to delete a user ---
  Future<void> deleteUser(String uid) async {
    await FirebaseFirestore.instance.collection("users").doc(uid).delete();
  }

  // --- Function to block a user temporarily ---
  Future<void> blockUser(String uid, Duration duration) async {
    final blockedUntil = DateTime.now().add(duration);
    await FirebaseFirestore.instance.collection("users").doc(uid).update({
      "blocked": true,
      "blockedUntil": blockedUntil.millisecondsSinceEpoch,
    });
  }

  // --- Function to unblock a user ---
  Future<void> unblockUser(String uid) async {
    await FirebaseFirestore.instance.collection("users").doc(uid).update({
      "blocked": false,
      "blockedUntil": null,
    });
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
        child: Column(
          children: [
            const SizedBox(height: 55),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Gestion des utilisateurs",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 2),
                        blurRadius: 4,
                        color: Colors.black26,
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection("users").snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    }

                    final users = snapshot.data!.docs;

                    if (users.isEmpty) {
                      return const Center(
                        child: Text(
                          "Aucun utilisateur trouvé.",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final data = users[index].data() as Map<String, dynamic>;
                        final uid = users[index].id;
                        final name = data["name"] ?? "Utilisateur";
                        final email = data["email"] ?? "Email inconnu";
                        final profile = data["profileImage"] ?? "";
                        final isBlocked = data["blocked"] ?? false;

                        ImageProvider imageProvider;
                        if (profile.isNotEmpty) {
                          if (profile.startsWith('http')) {
                            imageProvider = NetworkImage(profile);
                          } else {
                            imageProvider = AssetImage(profile);
                          }
                        } else {
                          imageProvider = const AssetImage("assets/imageP/default.png");
                        }

                        return GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              builder: (_) => Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      leading: const Icon(Icons.delete, color: Colors.red),
                                      title: const Text(
                                        "Supprimer l'utilisateur",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      onTap: () async {
                                        await deleteUser(uid);
                                        Navigator.pop(context);
                                      },
                                    ),
                                    const Divider(color: Colors.white24),
                                    ListTile(
                                      leading: Icon(
                                        isBlocked ? Icons.lock_open : Icons.lock,
                                        color: Colors.orange,
                                      ),
                                      title: Text(
                                        isBlocked
                                            ? "Débloquer l'utilisateur"
                                            : "Bloquer l'utilisateur",
                                        style: const TextStyle(color: Colors.orange),
                                      ),
                                      onTap: () async {
                                        Navigator.pop(context); // Close main menu

                                        if (isBlocked) {
                                          await unblockUser(uid);
                                        } else {
                                          // --- Show duration selection dialog ---
                                          final duration = await showDialog<Duration>(
                                            context: context,
                                            builder: (_) => SimpleDialog(
                                              title: const Text("Durée du blocage"),
                                              children: [
                                                SimpleDialogOption(
                                                  child: const Text("5 minutes"),
                                                  onPressed: () => Navigator.pop(context, const Duration(minutes: 5)),
                                                ),
                                                SimpleDialogOption(
                                                  child: const Text("1 heure"),
                                                  onPressed: () => Navigator.pop(context, const Duration(hours: 1)),
                                                ),
                                                SimpleDialogOption(
                                                  child: const Text("1 jour"),
                                                  onPressed: () => Navigator.pop(context, const Duration(days: 1)),
                                                ),
                                              ],
                                            ),
                                          );

                                          if (duration != null) {
                                            await blockUser(uid, duration);
                                          }
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.25),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.15),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.white.withOpacity(0.25),
                                      backgroundImage: imageProvider,
                                    ),
                                    const SizedBox(width: 18),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            name,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            email,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white.withOpacity(0.9),
                                            ),
                                          ),
                                          if (isBlocked)
                                            const Text(
                                              "Utilisateur bloqué",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.redAccent,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 18,
                                      color: Colors.white70,
                                    ),
                                  ],
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
            ),
          ],
        ),
      ),
    );
  }
}
