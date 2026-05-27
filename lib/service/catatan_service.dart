import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crud/service/config.dart';

class CatatanService {
  final String baseUrl = Config.baseUrl;

  Future<List<dynamic>> getRecentActivity({int? userId}) async {
    String url = "$baseUrl/catatan_recent";
    if (userId != null) {
      url += "?id_guru=$userId";
    }
    try {
      final response = await http.get(Uri.parse(url)).timeout(Duration(seconds: 10));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      print("❌ Error getRecentActivity: $e");
      return [];
    }
  }

  Future<bool> addCatatan(Map<String, dynamic> data) async {
    final url = "$baseUrl/catatan_siswa";
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final resData = jsonDecode(response.body);
        return resData['status'] == true;
      }
      return false;
    } catch (e) {
      print("❌ Error addCatatan: $e");
      return false;
    }
  }
}
