import 'package:flutter/foundation.dart';

import '../models/user.dart';
import '../services/auth_service.dart';

class AuthController extends ChangeNotifier {
  AuthController({AuthService? authService})
      : _authService = authService ?? AuthService();

  final AuthService _authService;

  bool isLoading = false;
  String? errorMessage;

  User? currentUser;
  String? token;

  bool get isLoggedIn => currentUser != null && token != null;

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? phone,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final user = await _authService.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        phone: phone,
      );
      currentUser = user;
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = _extractMessage(e);
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final result = await _authService.login(email: email, password: password);
      currentUser = result.user;
      token = result.token;
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = _extractMessage(e);
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProfile(String name) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      currentUser = await _authService.updateProfile(name);
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = _extractMessage(e);
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _authService.logout();
      currentUser = null;
      token = null;
    } catch (e) {
      errorMessage = _extractMessage(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  String _extractMessage(Object e) => e.toString().replaceFirst('Exception: ', '');
}
