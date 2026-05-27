import 'package:flutter/material.dart';
import '../service/catatan_service.dart';

class CatatanRecent {
  final int id;
  final String namaSiswa;
  final String namaCatatan;
  final String tipe;
  final int poin;
  final String tanggal;

  CatatanRecent({
    required this.id,
    required this.namaSiswa,
    required this.namaCatatan,
    required this.tipe,
    required this.poin,
    required this.tanggal,
  });

  factory CatatanRecent.fromJson(Map<String, dynamic> json) {
    return CatatanRecent(
      id: json['id_catatan'],
      namaSiswa: json['nama_siswa'],
      namaCatatan: json['nama_catatan'],
      tipe: json['tipe'],
      poin: json['poin'],
      tanggal: json['tanggal'],
    );
  }
}

class CatatanViewModel extends ChangeNotifier {
  final CatatanService _service = CatatanService();
  List<CatatanRecent> _recentList = [];
  List<CatatanRecent> get recentList => _recentList;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchRecent({int? userId}) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final data = await _service.getRecentActivity(userId: userId);
      _recentList = data.map((item) => CatatanRecent.fromJson(item)).toList();
    } catch (e) {
      print("❌ Error fetchRecent: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
