import 'dart:convert';
import 'package:chimini/secrets.dart';
import 'package:http/http.dart' as http;

class OpenAIService {
  final List<Map<String,String>> messages = [];
  Future<String> GeminiAPI(String prompt) async {
    messages.add({
      'role' : 'user',
      'content' : prompt,
    });
    final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$OpenApiKey');

    final requestBody = jsonEncode({
      "contents": [
        {
          "parts": [
            {
              "text": prompt
            }
          ],
          'role' : 'user'
        }
      ]
    });
    final headers = {'Content-Type': 'application/json'};

    print('Request URL: $url');
    print('Request Headers: $headers');
    print('Request Body: $requestBody');

    try {
      final response = await http.post(url, headers: headers, body: requestBody);

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // Parse the JSON response
        final responseData = jsonDecode(response.body);

        print('Parsed Response Data: $responseData');

        // Extract the generated text
        final generatedText =
        responseData['candidates'][0]['content']['parts'][0]['text'].trim();

        messages.add({
          'role' : 'assistent',
          'content' : generatedText,
        });
        print(generatedText);

        return generatedText;
      } else {
        throw Exception(
            'Failed to fetch response: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to fetch response: $e');
    }
  }

  Future<String> ImageApi(String prompt) async {
    final String url = 'https://image.pollinations.ai/prompt/$prompt';

    try {
      // Send GET request to the API
      final response = await http.get(Uri.parse(url));
      print("Ting Tong");

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Return the image as bytes (Uint8List)
        print(response.bodyBytes);
        return response.bodyBytes.toString();
      } else {
        print('Failed to load image. Status code: ${response.statusCode}');
        return Future.error('Failed to load image');
      }
    } catch (e) {
      print('Error: $e');
      return Future.error('Error: $e');
    }
  }

}
