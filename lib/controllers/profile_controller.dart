import 'package:flutter/foundation.dart';

import '../models/user.dart';
import '../services/profile_service.dart';

class ProfileController extends ChangeNotifier {
  ProfileController({ProfileService? profileService})
      : _profileService = profileService ?? ProfileService();

  final ProfileService _profileService;

  bool isLoading = false;
  String? errorMessage;

  User? profile;

  Future<void> loadProfile(int userId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      profile = await _profileService.getProfile(userId);
    } catch (e) {
      errorMessage = _extractMessage(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProfile({
    required int userId,
    String? name,
    String? email,
    String? phone,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      profile = await _profileService.updateProfile(
        userId: userId,
        name: name,
        email: email,
        phone: phone,
      );
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

  String _extractMessage(Object e) => e.toString().replaceFirst('Exception: ', '');
}
