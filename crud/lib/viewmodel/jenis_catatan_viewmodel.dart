import 'package:flutter/material.dart';
import '../model/jenis_catatan_model.dart';
import '../repository/jenis_catatan_repository.dart';

class JenisCatatanViewModel extends ChangeNotifier {
  final repo = JenisCatatanRepository();

  List<JenisCatatan> list = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchData(String tipe) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      list = await repo.getByTipe(tipe);
      debugPrint("✅ Berhasil fetch ${list.length} data $tipe");

      if (list.isEmpty) {
        errorMessage = "Tidak ada data untuk $tipe";
      }
    } catch (e) {
      errorMessage = "❌ Error: $e";
      debugPrint("❌ Error fetch: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<bool> addData(JenisCatatan item) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final isSuccess = await repo.addJenisCatatan(item);
      if (isSuccess) {
        await fetchData(item.tipe); // Refresh list
      }
      return isSuccess;
    } catch (e) {
      errorMessage = "❌ Error: $e";
      debugPrint("❌ Error addData: $e");
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateData(JenisCatatan item) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final isSuccess = await repo.updateJenisCatatan(item);
      if (isSuccess) {
        await fetchData(item.tipe); // Refresh list
      }
      return isSuccess;
    } catch (e) {
      errorMessage = "❌ Error: $e";
      debugPrint("❌ Error updateData: $e");
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteData(int id, String tipe) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final isSuccess = await repo.deleteJenisCatatan(id);
      if (isSuccess) {
        await fetchData(tipe); // Refresh list
      }
      return isSuccess;
    } catch (e) {
      errorMessage = "❌ Error: $e";
      debugPrint("❌ Error deleteData: $e");
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
