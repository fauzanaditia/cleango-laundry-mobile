import 'package:flutter/foundation.dart';

import '../services/dashboard_service.dart';

class DashboardController extends ChangeNotifier {
  DashboardController({DashboardService? dashboardService})
      : _dashboardService = dashboardService ?? DashboardService();

  final DashboardService _dashboardService;

  bool isLoading = false;
  String? errorMessage;

  DashboardSummary? summary;

  Future<void> loadDashboardSummary() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      summary = await _dashboardService.getDashboardSummary();
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
