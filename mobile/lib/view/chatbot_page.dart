import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final TextEditingController controller = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  List<Map<String, String>> messages = [];

  // ---------------- AI API ----------------
  static const String apiKey = "YOUR_OPENAI_API_KEY"; // Replace with your OpenAI key

  Future<String> fetchAIResponse(String prompt) async {
    const url = "https://api.openai.com/v1/chat/completions";

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $apiKey",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "model": "gpt-4o-mini",
        "messages": [
          {"role": "user", "content": prompt}
        ],
        "max_tokens": 200,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["choices"][0]["message"]["content"];
    } else {
      return "⚠️ API Error: ${response.statusCode}";
    }
  }

  // ---------------- SEND MESSAGE ----------------
  void sendMessage() async {
    final text = controller.text.trim();
    if (text.isEmpty) return;

    final userId = auth.currentUser?.uid ?? "guest";

    // Add user message locally
    setState(() {
      messages.add({"role": "user", "text": text});
    });
    controller.clear();

    // Show typing indicator
    setState(() {
      messages.add({"role": "bot", "text": "..."});
    });

    try {
      // Save user message to Firestore
      await firestore.collection('messages').add({
        "userId": userId,
        "role": "user",
        "text": text,
        "timestamp": FieldValue.serverTimestamp(),
      });

      // Call AI API
      final reply = await fetchAIResponse(text);

      // Remove typing indicator & add bot message
      setState(() {
        messages.removeWhere((m) => m["text"] == "...");
        messages.add({"role": "bot", "text": reply});
      });

      // Save bot message to Firestore
      await firestore.collection('messages').add({
        "userId": userId,
        "role": "bot",
        "text": reply,
        "timestamp": FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error sending message: $e");
      setState(() {
        messages.removeWhere((m) => m["text"] == "...");
        messages.add({
          "role": "bot",
          "text": "⚠️ Unable to send message. Check your connection."
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff7F7CFF),
      appBar: AppBar(
        title: const Text("Assistant AI"),
        backgroundColor: const Color(0xff7F7CFF),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (_, i) {
                final msg = messages[i];
                final isUser = msg["role"] == "user";
                return Align(
                  alignment:
                  isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isUser
                          ? Colors.deepPurpleAccent
                          : Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(18),
                      border: isUser
                          ? null
                          : Border.all(color: Colors.white70, width: 1),
                    ),
                    child: Text(
                      msg["text"]!,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Input Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            color: Colors.white.withOpacity(0.05),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      hintStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white24,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: sendMessage,
                  ),
                )
              ],
            ),
          )

        ],
      ),
    );
  }
}
