import 'package:flutter/material.dart';
import '../service/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  String? _role;
  String? get role => _role;
  String? _username;
  String? get username => _username;
  String? _idNumber;
  String? get idNumber => _idNumber;
  int? _userId;
  int? get userId => _userId;

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _authService.login(username, password);
      final isSuccess = (result['status'] == true);
      
      _isLoading = false;
      if (!isSuccess) {
        _errorMessage = result['message'] ?? "Username atau password salah!";
        _role = null;
        _username = null;
        _idNumber = null;
      } else {
        final data = result['data'];
        _role = data['role'] as String;
        _username = data['nama'] as String;
        _idNumber = _role == 'guru' ? data['nip'] : data['nis'];
        _userId = int.tryParse(data['id'].toString());
      }
      notifyListeners();
      return isSuccess;
      
    } catch (e) {
      _isLoading = false;
      _errorMessage = "Koneksi Bermasalah!";
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _role = null;
    _username = null;
    _idNumber = null;
    _userId = null;
    _errorMessage = null;
    notifyListeners();
  }
}
