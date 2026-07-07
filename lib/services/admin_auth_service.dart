class AdminAuthService {
  static const _adminEmail = 'admin@cleango.com';
  static const _adminPassword = 'admin123';

  Future<String> login({required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 800));

    if (email.trim().toLowerCase() != _adminEmail || password != _adminPassword) {
      throw Exception('Email atau password admin salah');
    }

    return 'fake-admin-token.${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 400));
  }
}
