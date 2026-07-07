import '../models/laundry_status_log.dart';
import '../models/order.dart';
import '../models/order_item.dart';
import 'mock_data.dart';

/// Input for a single line item when creating a new order.
class OrderItemInput {
  final int serviceId;
  final double berat;
  final int qty;
  final double harga;

  OrderItemInput({
    required this.serviceId,
    required this.berat,
    required this.qty,
    required this.harga,
  });
}

class OrderDetail {
  final Order order;
  final List<OrderItem> items;
  final List<LaundryStatusLog> statusLogs;

  OrderDetail({
    required this.order,
    required this.items,
    required this.statusLogs,
  });
}

class OrderService {
  Future<Order> createOrder({
    required int userId,
    required PickupType pickupType,
    required List<OrderItemInput> items,
    String? catatan,
  }) async {
    await Future.delayed(const Duration(milliseconds: 900));

    if (items.isEmpty) {
      throw Exception('Order harus memiliki minimal satu layanan');
    }

    final now = DateTime.now();
    final orderId = MockData.nextOrderId++;
    final kodeOrder =
        'ORD${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${orderId.toString().padLeft(3, '0')}';

    double totalHarga = 0;
    for (final item in items) {
      final subtotal = item.berat * item.harga * item.qty;
      totalHarga += subtotal;
      MockData.orderItems.add(
        OrderItem(
          id: MockData.nextOrderItemId++,
          orderId: orderId,
          serviceId: item.serviceId,
          berat: item.berat,
          qty: item.qty,
          harga: item.harga,
          subtotal: subtotal,
          createdAt: now,
          updatedAt: now,
        ),
      );
    }

    final newOrder = Order(
      id: orderId,
      kodeOrder: kodeOrder,
      userId: userId,
      tanggalOrder: now,
      status: OrderStatus.baru,
      pickupType: pickupType,
      estimasiSelesai: null,
      totalHarga: totalHarga,
      catatan: catatan,
      createdAt: now,
      updatedAt: now,
    );

    MockData.orders.add(newOrder);
    MockData.statusLogs.add(
      LaundryStatusLog(
        id: MockData.nextStatusLogId++,
        orderId: orderId,
        status: OrderStatus.baru,
        keterangan: 'Pesanan berhasil dibuat, menunggu diterima outlet',
        createdAt: now,
      ),
    );

    return newOrder;
  }

  Future<List<Order>> getOrders({int? userId}) async {
    await Future.delayed(const Duration(milliseconds: 700));

    final orders = userId == null
        ? MockData.orders
        : MockData.orders.where((o) => o.userId == userId).toList();

    final sorted = List<Order>.of(orders)
      ..sort((a, b) => b.tanggalOrder.compareTo(a.tanggalOrder));

    return sorted;
  }

  Future<OrderDetail> getOrderDetail(int orderId) async {
    await Future.delayed(const Duration(milliseconds: 700));

    final order = MockData.orders.where((o) => o.id == orderId);
    if (order.isEmpty) {
      throw Exception('Order dengan id $orderId tidak ditemukan');
    }

    final items = MockData.orderItems.where((i) => i.orderId == orderId).toList();

    final logs = MockData.statusLogs.where((l) => l.orderId == orderId).toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

    return OrderDetail(order: order.first, items: items, statusLogs: logs);
  }

  /// Nama tampilan pelanggan untuk sebuah userId, dipakai layar admin.
  String getCustomerName(int userId) => MockData.userNames[userId] ?? 'Pelanggan';
}
