import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crud/service/config.dart';

class UserService {
  final String baseUrl = "${Config.baseUrl}/siswa";

  Future<List<dynamic>> getUsers() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // RAW JSON
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<void> createUser(Map<String, dynamic> data) async {
    print("📤 KIRIM DATA: $data");
    print("🔗 URL: $baseUrl");

    try {
      final response = await http
          .post(
            Uri.parse(baseUrl),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(data),
          )
          .timeout(Duration(seconds: 10));

      print("📊 STATUS CODE: ${response.statusCode}");
      print("📋 RESPONSE: ${response.body}");

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(
          '❌ Gagal simpan data! Status: ${response.statusCode}\nResponse: ${response.body}',
        );
      }
    } catch (e) {
      print("❌ ERROR CREATEUSER: $e");
      throw Exception('❌ Gagal kirim data: $e');
    }
  }

  Future<void> updateUser(int id, Map<String, dynamic> data) async {
    print("\n========== UPDATE USER ==========");
    print("✏️ UPDATE DATA ID: $id");
    print("📦 DATA YANG DIKIRIM: ${jsonEncode(data)}");
    print("🔗 URL: $baseUrl/$id");

    try {
      final response = await http
          .put(
            Uri.parse('$baseUrl/$id'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(data),
          )
          .timeout(Duration(seconds: 10));

      print("📊 STATUS CODE: ${response.statusCode}");
      print("📋 RESPONSE BODY: ${response.body}");
      print("==================================\n");

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(
          '❌ Gagal update data! Status: ${response.statusCode}\nResponse: ${response.body}',
        );
      }
    } catch (e) {
      print("❌ ERROR UPDATEUSER: $e");
      print("==================================\n");
      throw Exception('❌ Gagal update data: $e');
    }
  }

  Future<void> deleteUser(int id) async {
    print("🗑️ HAPUS DATA ID: $id");
    print("🔗 URL: $baseUrl/$id");

    try {
      final response = await http
          .delete(
            Uri.parse('$baseUrl/$id'),
            headers: {'Accept': 'application/json'},
          )
          .timeout(Duration(seconds: 10));

      print("📊 STATUS CODE: ${response.statusCode}");
      print("📋 RESPONSE: ${response.body}");

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception(
          '❌ Gagal hapus data! Status: ${response.statusCode}\nResponse: ${response.body}',
        );
      }
    } catch (e) {
      print("❌ ERROR DELETEUSER: $e");
      throw Exception('❌ Gagal hapus data: $e');
    }
  }
}
