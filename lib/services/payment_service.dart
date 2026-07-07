import '../models/payment.dart';
import 'mock_data.dart';

class PaymentService {
  Future<Payment> createPayment({
    required int orderId,
    required PaymentMethod metode,
    required double jumlahBayar,
    String? buktiBayar,
    String? catatan,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final order = MockData.orders.where((o) => o.id == orderId);
    if (order.isEmpty) {
      throw Exception('Order dengan id $orderId tidak ditemukan');
    }

    final now = DateTime.now();
    final lunas = jumlahBayar >= order.first.totalHarga;

    final payment = Payment(
      id: MockData.nextPaymentId++,
      orderId: orderId,
      metode: metode,
      jumlahBayar: jumlahBayar,
      status: lunas ? PaymentStatus.lunas : PaymentStatus.belumLunas,
      tanggalBayar: lunas ? now : null,
      buktiBayar: buktiBayar,
      catatan: catatan,
      createdAt: now,
      updatedAt: now,
    );

    MockData.payments.add(payment);
    return payment;
  }

  Future<PaymentStatus> getPaymentStatus(int orderId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final orderPayments = MockData.payments.where((p) => p.orderId == orderId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    if (orderPayments.isEmpty) {
      return PaymentStatus.belumLunas;
    }

    return orderPayments.first.status;
  }

  Future<List<Payment>> getPayments() async {
    await Future.delayed(const Duration(milliseconds: 700));

    final sorted = List<Payment>.of(MockData.payments)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return sorted;
  }
}
