import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/viewmodel/auth_view_model.dart';
import 'package:demo/viewmodel/course_view_model.dart';
import 'package:demo/models/course_model.dart';
import 'package:demo/view/course_details_page.dart';
import 'package:demo/view/my_wallet_page.dart';
import 'package:demo/view/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final String? userId;
  final String? userEmail;
  final String? profileImage;

  const HomePage({super.key, this.userId, this.userEmail, this.profileImage});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String query = "";
  bool showChat = false;

  // Chatbot
  final TextEditingController chatController = TextEditingController();
  List<Map<String, dynamic>> messages = [];
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Draggable bubble
  double bubbleX = 25;
  double bubbleY = 600;

  // ---------------------- USER INFO ----------------------
  String get email => FirebaseAuth.instance.currentUser?.email ?? "";
  String get name => FirebaseAuth.instance.currentUser?.displayName ?? "";

  // ---------------- CHATBOT LOGIC ----------------
  String getBotResponse(String text) {
    final msg = text.toLowerCase();
    if (msg.contains("hi") || msg.contains("hello")) {
      return "Hello! How can I help you today?";
    } else if (msg.contains("how are you")) {
      return "I'm doing well! And you?";
    } else if (msg.contains("bye")) {
      return "Goodbye! Have a great day!";
    } else if (msg.contains("help")) {
      return "Sure! You can ask me about courses or your wallet.";
    }
    return "Sorry, I didn't understand that.";
  }

  // ------------------- SAVE MESSAGES -----------------
  Future<void> saveMessage(String role, String text, {bool read = true}) async {
    final userId = auth.currentUser?.uid ?? "guest";

    await firestore
        .collection("users")
        .doc(userId)
        .collection("messages")
        .add({
      "role": role,
      "text": text,
      "timestamp": FieldValue.serverTimestamp(),
      "read": read,
    });
  }

  // ------------------- SEND MESSAGE -----------------
  void sendMessage() async {
    final text = chatController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add({"role": "user", "text": text});
    });

    await saveMessage("user", text);
    chatController.clear();

    final reply = getBotResponse(text);

    setState(() {
      messages.add({"role": "bot", "text": reply});
    });

    await saveMessage("bot", reply);
  }

  // ------------------- SEND ADMIN MESSAGE -----------------
  Future<void> sendAdminMessage(String userId, String text) async {
    await firestore
        .collection("users")
        .doc(userId)
        .collection("messages")
        .add({
      "role": "admin",
      "text": text,
      "timestamp": FieldValue.serverTimestamp(),
      "read": false,
    });
  }

  // ----------------------------- UI ---------------------------------
  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);
    final courseVM = Provider.of<CourseViewModel>(context, listen: false);

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // FULLSCREEN BACKGROUND GRADIENT
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xff7F7CFF),
                    Color(0xffA77BFF),
                    Color(0xffD77BFF),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  buildTopBar(authVM),
                  const SizedBox(height: 20),
                  buildSearchBar(),
                  const SizedBox(height: 20),
                  Expanded(
                    child: StreamBuilder<List<Course>>(
                      stream: courseVM.getCoursesStream(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(color: Colors.white),
                          );
                        }

                        List<Course> courses = snapshot.data ?? [];
                        courses = courses
                            .where((c) => c.title.toLowerCase().contains(query.toLowerCase()))
                            .toList();

                        if (courses.isEmpty) {
                          return const Center(
                            child: Text(
                              "Aucun cours trouvé.",
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }

                        final freeCourses = courses.where((c) => c.price <= 0).toList();
                        final paidCourses = courses.where((c) => c.price > 0).toList();

                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (freeCourses.isNotEmpty) ...[
                                sectionHeader("Short and sweet", "courses for you"),
                                horizontalList(context, freeCourses),
                              ],
                              const SizedBox(height: 25),
                              if (paidCourses.isNotEmpty) ...[
                                sectionHeader("Top courses in", "Business"),
                                horizontalList(context, paidCourses),
                              ],
                              const SizedBox(height: 25),
                              sectionHeader("All", "courses"),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.78,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                ),
                                itemCount: courses.length,
                                itemBuilder: (context, i) => gridCourseCard(context, courses[i]),
                              ),
                              const SizedBox(height: 30),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // DRAGGABLE CHAT BUBBLE WITH NOTIFICATION
          StreamBuilder<QuerySnapshot>(
            stream: firestore
                .collection("users")
                .doc(auth.currentUser!.uid)
                .collection("messages")
                .where("role", isEqualTo: "admin")
                .where("read", isEqualTo: false)
                .snapshots(),
            builder: (context, snapshot) {
              final unreadCount = snapshot.data?.docs.length ?? 0;

              return Positioned(
                left: bubbleX,
                top: bubbleY,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      bubbleX += details.delta.dx;
                      bubbleY += details.delta.dy;
                    });
                  },
                  onTap: () async {
                    setState(() => showChat = !showChat);

                    if (showChat) {
                      // Mark all admin messages as read
                      final userId = auth.currentUser!.uid;
                      final unreadMessages = await firestore
                          .collection("users")
                          .doc(userId)
                          .collection("messages")
                          .where("role", isEqualTo: "admin")
                          .where("read", isEqualTo: false)
                          .get();

                      for (var doc in unreadMessages.docs) {
                        doc.reference.update({"read": true});
                      }
                    }
                  },
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xff7F7CFF), Color(0xffA77BFF), Color(0xffD77BFF)],
                          ),
                          border: Border.all(color: Colors.white70),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(.25), blurRadius: 12)],
                        ),
                        child: const Icon(Icons.smart_toy, color: Colors.white, size: 30),
                      ),
                      if (unreadCount > 0)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              "$unreadCount",
                              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),

          // CHAT WINDOW
          AnimatedPositioned(
            duration: const Duration(milliseconds: 350),
            bottom: showChat ? 100 : -450,
            right: 20,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: showChat ? 1 : 0,
              child: buildChatWindow(),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------- TOP BAR ------------------------
  Widget buildTopBar(AuthViewModel authVM) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FutureBuilder<DocumentSnapshot?>(
          future: authVM.user != null
              ? FirebaseFirestore.instance.collection('users').doc(authVM.user!.uid).get()
              : Future.value(null),
          builder: (context, snapshot) {
            final data = snapshot.data?.data() as Map<String, dynamic>?;
            final profilePath = data?['profileImage'];

            ImageProvider imageProvider;
            if (profilePath != null && profilePath.isNotEmpty) {
              imageProvider = profilePath.startsWith('http')
                  ? NetworkImage(profilePath)
                  : AssetImage(profilePath) as ImageProvider;
            } else {
              imageProvider = const AssetImage("assets/imageP/default.png");
            }

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ProfilePage(userEmail: email, userName: name)),
                );
              },
              child: CircleAvatar(
                radius: 22,
                backgroundImage: imageProvider,
                backgroundColor: Colors.white.withOpacity(.4),
              ),
            );
          },
        ),
        Image.asset("assets/logo/9a9a.png", height: 70),
        IconButton(
          icon: const Icon(Icons.account_balance_wallet_outlined, color: Colors.white, size: 28),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MyWalletPage(
                  balance: Provider.of<AuthViewModel>(context, listen: false).walletBalance ?? 0.0,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // ------------------------ SEARCH BAR -----------------------------
  Widget buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.25),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        onChanged: (value) => setState(() => query = value.toLowerCase()),
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          hintText: "Search for a course...",
          hintStyle: TextStyle(color: Colors.white70),
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search, color: Colors.white),
          contentPadding: EdgeInsets.all(14),
        ),
      ),
    );
  }

  // ------------------------ CHAT WINDOW ----------------------------
  Widget buildChatWindow() {
    final userId = auth.currentUser!.uid;

    return StreamBuilder<QuerySnapshot>(
      stream: firestore
          .collection("users")
          .doc(userId)
          .collection("messages")
          .orderBy("timestamp", descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(
            width: 300,
            height: 380,
            child: Center(child: CircularProgressIndicator(color: Colors.white)),
          );
        }

        final msgs = snapshot.data!.docs;

        return Container(
          width: 300,
          height: 380,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xff7F7CFF), Color(0xffA77BFF), Color(0xffD77BFF)],
            ),
            border: Border.all(color: Colors.white60),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 18)],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "AI Assistant",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 19),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => showChat = false),
                    child: const Icon(Icons.close, color: Colors.white, size: 22),
                  )
                ],
              ),
              const SizedBox(height: 15),
              Expanded(
                child: ListView.builder(
                  itemCount: msgs.length,
                  itemBuilder: (_, i) {
                    final data = msgs[i].data() as Map<String, dynamic>;
                    final role = data["role"];
                    final isUser = role == "user";

                    return Align(
                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: isUser
                              ? Colors.deepPurpleAccent
                              : Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          data["text"] ?? "",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.25),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: chatController,
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
                      onPressed: sendMessage,
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  // ---------------------- COURSE SECTIONS -----------------------
  Widget sectionHeader(String b1, String b2) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: RichText(
        text: TextSpan(
          text: "$b1 ",
          style: const TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
          children: [
            TextSpan(
              text: b2,
              style: const TextStyle(color: Color(0xffFFD66B), fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }

  Widget horizontalList(BuildContext context, List<Course> list) {
    return SizedBox(
      height: 230,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        itemBuilder: (context, index) => horizontalCard(context, list[index]),
      ),
    );
  }

  Widget horizontalCard(BuildContext context, Course c) {
    return GestureDetector(
      onTap: () => openCourse(context, c),
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.25),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withOpacity(.3)),
          boxShadow: [BoxShadow(color: Colors.black12.withOpacity(0.2), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
              child: Image.asset(c.photoAsset, height: 120, width: double.infinity, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(c.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 5),
                  Text(c.price <= 0 ? "Free" : "${c.price} DT", style: const TextStyle(fontSize: 15, color: Color(0xffFFD66B), fontWeight: FontWeight.bold)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget gridCourseCard(BuildContext context, Course c) {
    return GestureDetector(
      onTap: () => openCourse(context, c),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.25),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white24),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(c.photoAsset, height: 95, width: double.infinity, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(c.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(c.price <= 0 ? "Free" : "${c.price} DT", style: const TextStyle(fontSize: 14, color: Color(0xffFFD66B), fontWeight: FontWeight.bold)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void openCourse(BuildContext context, Course c) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => CourseDetailsPage(course: c)));
  }
}
