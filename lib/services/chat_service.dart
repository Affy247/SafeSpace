// lib/services/chat_service.dart
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ChatService {
  static const String _apiUrl = "https://openrouter.ai/api/v1/chat/completions";

  Future<String> sendMessage(String userMessage) async {
    final apiKey = dotenv.env['OPENROUTER_API_KEY'];

    if (apiKey == null || apiKey.isEmpty) {
      return "⚠️ Missing OpenRouter API key. Please check your .env file.";
    }

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          "Authorization": "Bearer $apiKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "model": "meta-llama/llama-3.1-70b-instruct",
          "messages": [
            {
              "role": "system",
              "content": "You are SafeSpace AI — an empathetic mental wellbeing companion. Use a gentle caring tone, avoid medical advice and be supportive."
            },
            {"role": "user", "content": userMessage}
          ],
          "temperature": 0.8,
          "max_tokens": 300,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        try {
          return data["choices"][0]["message"]["content"].toString().trim();
        } catch (_) {
          return "⚠️ Unexpected response format from AI.";
        }
      } else {
        return "⚠️ Error: ${response.statusCode} ${response.reasonPhrase}";
      }
    } catch (e) {
      return "⚠️ Network error: $e";
    }
  }
}
