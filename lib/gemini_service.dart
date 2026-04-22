import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GeminiService {
  static const String apiKey = 'AIzaSyDhsVQn2ZAzL73GtKWqT_iDmdS04x0rCNs';

  Future<String> askAI(String prompt) async {
    try {
      final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1/models/gemini-2.0-flash:generateContent',
      );

      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'x-goog-api-key': apiKey,
            },
            body: jsonEncode({
              "contents": [
                {
                  "parts": [
                    {"text": prompt}
                  ]
                }
              ]
            }),
          )
          .timeout(const Duration(seconds: 5));
      debugPrint(response.body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        String text = data['candidates']?[0]?['content']?['parts']?[0]
                ?['text'] ??
            "No response";

        // clean little bit
        text = text.replaceAll('**', '');
        text = text.replaceAll('*   ', '• ');
        text = text.replaceAll('* ', '• ');

        return text;
      } else {
        return "Error: ${response.body}";
      }
    } catch (e) {
      if (e.toString().contains('Timeout')) {
        return "Error: Timeout";
      }
      return "Error: $e";
    }
  }
}
