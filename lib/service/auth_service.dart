import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crud/service/config.dart';

class AuthService {
  final String baseUrl = "${Config.baseUrl}/login";

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse(baseUrl),

            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'username': username,
              'password': password,
            }),
          )
          .timeout(Duration(seconds: 10));

      print("🔐 STATUS CODE LOGIN: ${response.statusCode}");
      print("📋 RESPONSE BODY: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 401) {
        return jsonDecode(response.body);
      }
      return {'status': false, 'message': 'Gagal terhubung ke server'};
    } catch (e) {
      print("❌ ERROR LOGIN: $e");
      throw Exception('❌ Gagal melakukan verifikasi: $e');
    }
  }
}
