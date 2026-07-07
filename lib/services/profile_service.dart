import '../models/user.dart';
import 'mock_data.dart';

class ProfileService {
  Future<User> getProfile(int userId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final user = MockData.users.where((u) => u.id == userId);
    if (user.isEmpty) {
      throw Exception('User dengan id $userId tidak ditemukan');
    }

    return user.first;
  }

  Future<User> updateProfile({
    required int userId,
    String? name,
    String? email,
    String? phone,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final index = MockData.users.indexWhere((u) => u.id == userId);
    if (index == -1) {
      throw Exception('User dengan id $userId tidak ditemukan');
    }

    final current = MockData.users[index];
    final updated = User(
      id: current.id,
      name: name ?? current.name,
      email: email ?? current.email,
      phone: phone ?? current.phone,
      password: current.password,
      createdAt: current.createdAt,
      updatedAt: DateTime.now(),
    );

    MockData.users[index] = updated;
    return updated;
  }
}
