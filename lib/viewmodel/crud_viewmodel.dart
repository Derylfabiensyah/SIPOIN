import 'package:flutter/material.dart';
import '../model/crud_model.dart';
import '../repository/crud_repository.dart';

class CrudViewModel extends ChangeNotifier {
  final UserRepository repo;

  CrudViewModel(this.repo) {
    fetchUsers(); // Load data saat pertama kali buka app
  }

  bool isLoading = false;
  List<User> users = [];

  Future<void> fetchUsers() async {
    isLoading = true;
    notifyListeners();

    try {
      users = await repo.getUsers();
      print("✅ Berhasil fetch ${users.length} data");
    } catch (e) {
      print("❌ Error fetch: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> addUser(User user) async {
    try {
      await repo.createUser(user);
      print("✅ User ditambah, refresh data...");
      await fetchUsers();
    } catch (e) {
      print("❌ Error add: $e");
    }
  }

  Future<void> editUser(User user) async {
    try {
      await repo.updateUser(user);
      print("✅ User diupdate, refresh data...");
      await fetchUsers();
    } catch (e) {
      print("❌ Error edit: $e");
    }
  }

  Future<void> removeUser(int id) async {
    try {
      await repo.deleteUser(id);
      print("✅ User dihapus, refresh data...");
      await fetchUsers();
    } catch (e) {
      print("❌ Error delete: $e");
    }
  }
}