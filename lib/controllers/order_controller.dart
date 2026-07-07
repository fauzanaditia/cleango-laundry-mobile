import 'package:flutter/foundation.dart';

import '../models/order.dart';
import '../services/order_service.dart';

class OrderController extends ChangeNotifier {
  OrderController({OrderService? orderService})
      : _orderService = orderService ?? OrderService();

  final OrderService _orderService;

  bool isLoading = false;
  String? errorMessage;

  List<Order> orders = [];
  OrderDetail? orderDetail;

  Future<Order?> createOrder({
    required int userId,
    required PickupType pickupType,
    required List<OrderItemInput> items,
    String? catatan,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final order = await _orderService.createOrder(
        userId: userId,
        pickupType: pickupType,
        items: items,
        catatan: catatan,
      );
      orders = [order, ...orders];
      isLoading = false;
      notifyListeners();
      return order;
    } catch (e) {
      errorMessage = _extractMessage(e);
      isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<void> loadOrders({int? userId}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      orders = await _orderService.getOrders(userId: userId);
    } catch (e) {
      errorMessage = _extractMessage(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadOrderDetail(int orderId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      orderDetail = await _orderService.getOrderDetail(orderId);
    } catch (e) {
      errorMessage = _extractMessage(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  String customerName(int userId) => _orderService.getCustomerName(userId);

  String _extractMessage(Object e) => e.toString().replaceFirst('Exception: ', '');
}
