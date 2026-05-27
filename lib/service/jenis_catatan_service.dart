import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crud/service/config.dart';

class JenisCatatanService {
  final String baseUrl = Config.baseUrl;

  Future<List<dynamic>> getByTipe(String tipe) async {
    final url = "$baseUrl/jenis_catatan/$tipe";
    print("🔗 URL: $url");

    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(Duration(seconds: 10));

      print("📊 STATUS CODE: ${response.statusCode}");
      print("📋 RESPONSE BODY: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = jsonDecode(response.body);
        print("✅ Berhasil ambil ${data.length} data");
        return data;
      } else {
        throw Exception(
          '❌ Gagal ambil data! Status: ${response.statusCode}\nResponse: ${response.body}',
        );
      }
    } catch (e) {
      print("❌ ERROR GETBYTIPE: $e");
      throw Exception('❌ Gagal ambil data: $e');
    }
  }

  Future<bool> addJenisCatatan(Map<String, dynamic> data) async {
    final url = "$baseUrl/jenis_catatan";
    print("🔗 POST URL: $url");

    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(data),
          )
          .timeout(Duration(seconds: 10));

      print("📊 STATUS CODE: ${response.statusCode}");
      print("📋 RESPONSE BODY: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final resData = jsonDecode(response.body);
        return resData['status'] == true;
      } else {
        return false;
      }
    } catch (e) {
      print("❌ ERROR POST: $e");
      throw Exception('❌ Gagal menambah data: $e');
    }
  }

  Future<bool> updateJenisCatatan(int id, Map<String, dynamic> data) async {
    final url = "$baseUrl/jenis_catatan/$id";
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      ).timeout(Duration(seconds: 10));
      if (response.statusCode == 200) {
        final resData = jsonDecode(response.body);
        return resData['status'] == true;
      }
      return false;
    } catch (e) {
      print("❌ ERROR PUT: $e");
      throw Exception('❌ Gagal mengupdate data: $e');
    }
  }

  Future<bool> deleteJenisCatatan(int id) async {
    final url = "$baseUrl/jenis_catatan/$id";
    try {
      final response = await http.delete(Uri.parse(url)).timeout(Duration(seconds: 10));
      if (response.statusCode == 200) {
        final resData = jsonDecode(response.body);
        return resData['status'] == true;
      }
      return false;
    } catch (e) {
      print("❌ ERROR DELETE: $e");
      throw Exception('❌ Gagal menghapus data: $e');
    }
  }
}
