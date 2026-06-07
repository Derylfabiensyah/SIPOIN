import 'package:flutter/material.dart';
import '../service/api_service.dart';
import '../service/jenis_catatan_service.dart';
import '../service/catatan_service.dart';

class InputCatatanViewModel extends ChangeNotifier {
  final UserService _siswaService = UserService();
  final JenisCatatanService _jenisService = JenisCatatanService();
  final CatatanService _catatanService = CatatanService();

  List<dynamic> _listSiswa = [];
  List<dynamic> get listSiswa => _listSiswa;

  List<dynamic> _listJenis = [];
  List<dynamic> get listJenis => _listJenis;

  String? _selectedSiswaId;
  String? get selectedSiswaId => _selectedSiswaId;

  String? _selectedTipe;
  String? get selectedTipe => _selectedTipe;

  String? _selectedJenisId;
  String? get selectedJenisId => _selectedJenisId;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  Future<void> fetchSiswa() async {
    _isLoading = true;
    notifyListeners();
    try {
      _listSiswa = await _siswaService.getUsers();
    } catch (e) {
      print("❌ Error fetchSiswa: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSelectedSiswa(String? value) {
    _selectedSiswaId = value;
    notifyListeners();
  }

  void setSelectedTipe(String? value) {
    _selectedTipe = value;
    _selectedJenisId = null; // Reset jenis when tipe changes
    _listJenis = [];
    if (value != null) {
      fetchJenisCatatan(value);
    }
    notifyListeners();
  }

  void setSelectedJenis(String? value) {
    _selectedJenisId = value;
    notifyListeners();
  }

  Future<void> fetchJenisCatatan(String tipe) async {
    _isLoading = true;
    notifyListeners();
    try {
      _listJenis = await _jenisService.getByTipe(tipe);
    } catch (e) {
      print("❌ Error fetchJenisCatatan: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> submit(int idGuru) async {
    if (_selectedSiswaId == null || _selectedJenisId == null) {
      return false;
    }

    _isSubmitting = true;
    notifyListeners();

    try {
      final data = {
        'id_siswa': int.parse(_selectedSiswaId!),
        'id_jenis': int.parse(_selectedJenisId!),
        'id_guru': idGuru,
      };
      final success = await _catatanService.addCatatan(data);
      if (success) {
        resetForm();
      }
      return success;
    } catch (e) {
      print("❌ Error submit catatan: $e");
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  void resetForm() {
    _selectedSiswaId = null;
    _selectedTipe = null;
    _selectedJenisId = null;
    _listJenis = [];
    notifyListeners();
  }
}
