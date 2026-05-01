import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://your-api-base-url.com/api'; // 🔁 replace with your real URL

  static Future<Map<String, dynamic>> login({
    required String usernameOrEmail,
    required String password,
  }) async {
    final uri = Uri.parse('http://125.209.66.147:5001/api/auth/signin');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'usernameOrEmail': usernameOrEmail,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200) {
      return data;
    } else {
      throw Exception(data['message'] ?? data['error'] ?? 'Invalid credentials');
    }
  }
}