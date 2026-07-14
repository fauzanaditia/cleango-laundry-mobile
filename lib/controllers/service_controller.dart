import 'package:flutter/foundation.dart';

import '../models/service.dart';
import '../services/service_service.dart';

class ServiceController extends ChangeNotifier {
  ServiceController({ServiceService? serviceService})
      : _serviceService = serviceService ?? ServiceService();

  final ServiceService _serviceService;

  bool isLoading = false;
  String? errorMessage;

  List<Service> services = [];

  Future<void> loadServices() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      services = await _serviceService.getServices();
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
