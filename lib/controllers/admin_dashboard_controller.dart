import 'package:flutter/foundation.dart';

import '../services/admin_dashboard_service.dart';

class AdminDashboardController extends ChangeNotifier {
  AdminDashboardController({AdminDashboardService? adminDashboardService})
      : _adminDashboardService = adminDashboardService ?? AdminDashboardService();

  final AdminDashboardService _adminDashboardService;

  bool isLoading = false;
  String? errorMessage;

  AdminDashboardSummary? summary;

  Future<void> loadSummary() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      summary = await _adminDashboardService.getAdminDashboardSummary();
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
