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

  Future<bool> createService({
    required String name,
    required double price,
    required int duration,
    String? description,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final service = await _serviceService.createService(
        name: name,
        price: price,
        duration: duration,
        description: description,
      );
      services = [...services, service];
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
}
