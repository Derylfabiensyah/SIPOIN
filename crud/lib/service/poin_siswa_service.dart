import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crud/service/config.dart';

class PoinSiswaService {
  final String baseUrl = Config.baseUrl;

  /// Get total poin pelanggaran & prestasi untuk seorang siswa
  Future<Map<String, int>> getTotalPoin(int idSiswa) async {
    final url = "$baseUrl/poin_siswa/$idSiswa";
    try {
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'pelanggaran': (data['pelanggaran'] ?? 0) as int,
          'prestasi': (data['prestasi'] ?? 0) as int,
        };
      }
      return {'pelanggaran': 0, 'prestasi': 0};
    } catch (e) {
      print("❌ Error getTotalPoin: $e");
      return {'pelanggaran': 0, 'prestasi': 0};
    }
  }

  /// Get detail poin per tipe (pelanggaran/prestasi)
  Future<List<dynamic>> getDetailPoin(int idSiswa, String tipe) async {
    final url = "$baseUrl/poin_siswa_detail/$idSiswa/$tipe";
    try {
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      print("❌ Error getDetailPoin: $e");
      return [];
    }
  }
}
