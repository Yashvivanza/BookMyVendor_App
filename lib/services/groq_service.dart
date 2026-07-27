import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GroqService {
  final String apiKey =
      dotenv.env['GROQ_API_KEY'] ?? "";

  Future<String> sendMessage(
    String message,
  ) async {

    final response = await http.post(
      Uri.parse(
        "https://api.groq.com/openai/v1/chat/completions",
      ),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey",
      },
      body: jsonEncode({
        "model": "llama-3.3-70b-versatile",

        "messages": [
          {
            "role": "system",
            "content": """
You are the official AI Assistant for Book My Vendor.

You help users find vendors and services available in the Book My Vendor app.

Available categories include:
- Photographers
- Pandits
- Decorators
- Caterers
- Makeup Artists
- Event Planners
- DJs
- Wedding Services

Answer questions about:
- Vendor recommendations
- Event planning
- Booking services
- Ratings & Reviews
- Categories available
- App usage

If user asks unrelated questions, reply:

'I can only help with Book My Vendor services and vendors.'
"""
          },
          {
            "role": "user",
            "content": message
          }
        ]
      }),
    );

    if (response.statusCode == 200) {

      final data =
          jsonDecode(response.body);

      return data["choices"][0]
              ["message"]["content"] ??
          "No response";
    }

    throw Exception(
      "Groq Error : ${response.body}",
    );
  }
}