import 'package:flutter/material.dart';
import '../service/poin_siswa_service.dart';
import '../model/poin_detail_model.dart';

class PoinSiswaViewModel extends ChangeNotifier {
  final PoinSiswaService _service = PoinSiswaService();

  int _totalPelanggaran = 0;
  int get totalPelanggaran => _totalPelanggaran;

  int _totalPrestasi = 0;
  int get totalPrestasi => _totalPrestasi;

  List<PoinDetail> _detailList = [];
  List<PoinDetail> get detailList => _detailList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoadingDetail = false;
  bool get isLoadingDetail => _isLoadingDetail;

  /// Fetch total poin pelanggaran & prestasi untuk dashboard card
  Future<void> fetchTotalPoin(int idSiswa) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _service.getTotalPoin(idSiswa);
      _totalPelanggaran = int.tryParse(result['pelanggaran']?.toString() ?? '0') ?? 0;
      _totalPrestasi = int.tryParse(result['prestasi']?.toString() ?? '0') ?? 0;
    } catch (e) {
      print("❌ Error fetchTotalPoin: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Fetch detail poin per tipe untuk halaman detail
  Future<void> fetchDetailPoin(int idSiswa, String tipe) async {
    _isLoadingDetail = true;
    _detailList = [];
    notifyListeners();

    try {
      final data = await _service.getDetailPoin(idSiswa, tipe);
      _detailList = data.map((item) => PoinDetail.fromJson(item)).toList();
    } catch (e) {
      print("❌ Error fetchDetailPoin: $e");
    } finally {
      _isLoadingDetail = false;
      notifyListeners();
    }
  }
}
