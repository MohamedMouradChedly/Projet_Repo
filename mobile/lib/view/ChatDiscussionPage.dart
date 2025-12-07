import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'send_message.dart';

class ChatDiscussionPage extends StatefulWidget {
  final String userId;
  const ChatDiscussionPage({super.key, required this.userId});

  @override
  State<ChatDiscussionPage> createState() => _ChatDiscussionPageState();
}

class _ChatDiscussionPageState extends State<ChatDiscussionPage> {
  final TextEditingController _controller = TextEditingController();
  String? profileImageUrl;
  String userName = "User"; // Default name
  final String chatbotImageUrl = "assets/imageP/robocops.jpg"; // Chatbot image

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.userId)
          .get();

      final data = userDoc.data() as Map<String, dynamic>?;

      if (data != null) {
        profileImageUrl = (data["profileImage"] != null && data["profileImage"] != "")
            ? data["profileImage"]
            : null;
        userName = data["name"] ?? "User";
      } else {
        profileImageUrl = null;
      }

      setState(() {});
    } catch (e) {
      print("Error loading user data: $e");
      profileImageUrl = null;
      userName = "User";
      setState(() {});
    }
  }

  // Function to delete a message
  Future<void> deleteMessage(String messageId) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userId)
        .collection("messages")
        .doc(messageId)
        .delete();
  }

  // Function to modify a message
  Future<void> modifyMessage(String messageId, String currentText) async {
    TextEditingController editController = TextEditingController(text: currentText);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Modify Message"),
          content: TextField(
            controller: editController,
            decoration: const InputDecoration(
              hintText: "Edit your message",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                if (editController.text.trim().isNotEmpty) {
                  await FirebaseFirestore.instance
                      .collection("users")
                      .doc(widget.userId)
                      .collection("messages")
                      .doc(messageId)
                      .update({"text": editController.text.trim()});
                }
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
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
        child: SafeArea(
          child: Column(
            children: [
              // Custom AppBar with avatar + name
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                height: 70,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundImage: profileImageUrl != null
                          ? (profileImageUrl!.startsWith("http")
                          ? NetworkImage(profileImageUrl!)
                          : AssetImage(profileImageUrl!) as ImageProvider)
                          : const AssetImage("assets/imageP/default.png"),
                      backgroundColor: Colors.transparent,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),

              // Messages List
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(widget.userId)
                      .collection("messages")
                      .orderBy("timestamp", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final messages = snapshot.data!.docs;

                    if (messages.isEmpty) {
                      return const Center(
                        child: Text(
                          "No messages yet",
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    return ListView.builder(
                      reverse: true,
                      padding: const EdgeInsets.all(12),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final data = messages[index].data() as Map<String, dynamic>;
                        final isUser = data["role"] == "user";
                        final text = data["text"] ?? "";
                        final messageId = messages[index].id;

                        // Determine avatar for message
                        ImageProvider avatarImage = isUser
                            ? (profileImageUrl != null
                            ? (profileImageUrl!.startsWith("http")
                            ? NetworkImage(profileImageUrl!)
                            : AssetImage(profileImageUrl!) as ImageProvider)
                            : const AssetImage("assets/imageP/default.png"))
                            : const AssetImage("assets/imageP/robocops.jpg");

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: GestureDetector(
                            onLongPress: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (_) => Wrap(
                                  children: [
                                    ListTile(
                                      leading: const Icon(Icons.edit),
                                      title: const Text("Modify"),
                                      onTap: () {
                                        Navigator.pop(context);
                                        modifyMessage(messageId, text);
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.delete),
                                      title: const Text("Delete"),
                                      onTap: () {
                                        Navigator.pop(context);
                                        deleteMessage(messageId);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: isUser
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (!isUser)
                                  CircleAvatar(
                                    radius: 14,
                                    backgroundImage: avatarImage,
                                    backgroundColor: Colors.transparent,
                                  ),
                                if (!isUser) const SizedBox(width: 8),
                                Flexible(
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: isUser
                                          ? Colors.deepPurpleAccent
                                          : Colors.white.withOpacity(0.8),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Text(
                                      text,
                                      style: TextStyle(
                                        color: isUser ? Colors.white : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                if (isUser) const SizedBox(width: 8),
                                if (isUser)
                                  CircleAvatar(
                                    radius: 14,
                                    backgroundImage: avatarImage,
                                    backgroundColor: Colors.transparent,
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              // Glassmorphic Input Field
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                hintText: "Type a message...",
                                hintStyle: TextStyle(color: Colors.white70),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.send, color: Colors.white),
                            onPressed: () {
                              if (_controller.text.trim().isNotEmpty) {
                                sendMessage(
                                  widget.userId,
                                  _controller.text.trim(),
                                  "admin",
                                );
                                _controller.clear();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
