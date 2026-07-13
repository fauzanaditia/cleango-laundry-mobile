import 'package:flutter/foundation.dart';

import '../models/payment.dart';
import '../services/payment_service.dart';

class PaymentController extends ChangeNotifier {
  PaymentController({PaymentService? paymentService})
      : _paymentService = paymentService ?? PaymentService();

  final PaymentService _paymentService;

  bool isLoading = false;
  String? errorMessage;

  Payment? payment;
  PaymentStatus? paymentStatus;

  Future<bool> createPayment({
    required int orderId,
    required PaymentMethod metode,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      payment = await _paymentService.createPayment(
        orderId: orderId,
        metode: metode,
      );
      paymentStatus = payment!.status;
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

  Future<bool> confirmPayment(int orderId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      payment = await _paymentService.confirmPayment(orderId);
      paymentStatus = payment!.status;
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

  Future<void> loadPaymentStatus(int orderId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      paymentStatus = await _paymentService.getPaymentStatus(orderId);
    } catch (e) {
      errorMessage = _extractMessage(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  String _extractMessage(Object e) => e.toString().replaceFirst('Exception: ', '');
}
