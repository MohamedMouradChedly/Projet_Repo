import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatAIService {
  static const String apiKey = "YOUR_OPENAI_API_KEY"; // put your key here

  static Future<String> sendMessage(String userMessage) async {
    const url = "https://api.openai.com/v1/chat/completions";

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey",
      },
      body: jsonEncode({
        "model": "gpt-4o-mini",
        "messages": [
          {"role": "user", "content": userMessage}
        ],
        "max_tokens": 200,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["choices"][0]["message"]["content"];
    } else {
      return "⚠️ Error: ${response.body}";
    }
  }
}
