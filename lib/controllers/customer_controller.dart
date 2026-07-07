import 'package:flutter/foundation.dart';

import '../models/customer.dart';
import '../services/customer_service.dart';

class CustomerController extends ChangeNotifier {
  CustomerController({CustomerService? customerService})
      : _customerService = customerService ?? CustomerService();

  final CustomerService _customerService;

  bool isLoading = false;
  String? errorMessage;

  List<Customer> customers = [];

  Future<void> loadCustomers({String? query}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      customers = await _customerService.getCustomers(query: query);
    } catch (e) {
      errorMessage = _extractMessage(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createCustomer({
    required String name,
    required String phone,
    String? email,
    String? address,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final customer = await _customerService.createCustomer(
        name: name,
        phone: phone,
        email: email,
        address: address,
      );
      customers = [customer, ...customers];
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
