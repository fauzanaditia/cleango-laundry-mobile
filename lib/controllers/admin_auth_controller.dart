import 'package:flutter/foundation.dart';

import '../services/admin_auth_service.dart';

class AdminAuthController extends ChangeNotifier {
  AdminAuthController({AdminAuthService? adminAuthService})
      : _adminAuthService = adminAuthService ?? AdminAuthService();

  final AdminAuthService _adminAuthService;

  bool isLoading = false;
  String? errorMessage;
  String? token;

  bool get isLoggedIn => token != null;

  Future<bool> login({required String email, required String password}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      token = await _adminAuthService.login(email: email, password: password);
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    isLoading = true;
    notifyListeners();
    await _adminAuthService.logout();
    token = null;
    isLoading = false;
    notifyListeners();
  }
}
