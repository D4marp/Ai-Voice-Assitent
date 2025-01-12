import 'dart:convert';
import 'package:http/http.dart' as http;


class AIService {
  final String apiKey;

  AIService(this.apiKey);

  Future<String> getAIResponse(String input) async {
    var url = Uri.parse("https://api.openai.com/v1/chat/completions");
    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey",
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {"role": "system", "content": "You are a helpful assistant."},
          {"role": "user", "content": input}
        ],
        "max_tokens": 100,
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data["choices"][0]["message"]["content"];
    } else {
      throw Exception("Failed to fetch AI response");
    }
  }
}
