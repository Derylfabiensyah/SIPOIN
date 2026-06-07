import '../model/crud_model.dart';
import '../service/api_service.dart';

class UserRepository {
  final UserService service;

  UserRepository(this.service);

  Future<List<User>> getUsers() async {
    final data = await service.getUsers();

    return data.map((e) => User.fromJson(e)).toList();
  }

  Future<void> createUser(User user) async {
    await service.createUser(user.toJson());
  }

  Future<void> updateUser(User user) async {
    await service.updateUser(user.id!, user.toJsonWithId());
  }

  Future<void> deleteUser(int id) async {
    await service.deleteUser(id);
  }
}
