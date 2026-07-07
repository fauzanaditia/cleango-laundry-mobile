import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/order_controller.dart';
import '../../controllers/payment_controller.dart';
import '../../models/order.dart';
import 'order_completion_screen.dart';
import 'order_draft.dart';

class PickupConfirmationScreen extends StatefulWidget {
  const PickupConfirmationScreen({super.key, required this.orderId});

  final int orderId;

  @override
  State<PickupConfirmationScreen> createState() => _PickupConfirmationScreenState();
}

class _PickupConfirmationScreenState extends State<PickupConfirmationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderController>().loadOrderDetail(widget.orderId);
      context.read<PaymentController>().loadPaymentStatus(widget.orderId);
    });
  }

  void _belumDiterima() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fitur bantuan akan segera hadir')),
    );
  }

  void _sudahDiterima() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const OrderCompletionScreen()),
    );
  }

  DateTime? _tanggalSelesai(Order order, OrderController orderController) {
    final logs = orderController.orderDetail?.statusLogs ?? [];
    for (final log in logs) {
      if (log.status == OrderStatus.selesai) return log.createdAt;
    }
    return order.estimasiSelesai;
  }

  @override
  Widget build(BuildContext context) {
    final orderController = context.watch<OrderController>();
    final paymentController = context.watch<PaymentController>();
    final authController = context.watch<AuthController>();
    final detail = orderController.orderDetail;
    final loading = orderController.isLoading || detail == null || detail.order.id != widget.orderId;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF14224D),
        title: const Text('Konfirmasi Pengambilan'),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      _Row('Kode Order', detail.order.kodeOrder),
                      const SizedBox(height: 10),
                      _Row('Tanggal Selesai', formatTanggalWaktuIndo(_tanggalSelesai(detail.order, orderController)!)),
                      const SizedBox(height: 10),
                      _Row('Nama', authController.currentUser?.name ?? '-'),
                      const SizedBox(height: 10),
                      _Row('Total Bayar', formatRupiah(detail.order.totalHarga)),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Status Pembayaran', style: TextStyle(color: Colors.grey)),
                          if (paymentController.paymentStatus != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: paymentStatusColor(paymentController.paymentStatus!).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                paymentStatusLabel(paymentController.paymentStatus!),
                                style: TextStyle(
                                  color: paymentStatusColor(paymentController.paymentStatus!),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                const Text(
                  'Apakah Anda sudah menerima pesanan ini?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _sudahDiterima,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E6BE6),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    minimumSize: const Size.fromHeight(0),
                  ),
                  child: const Text('YA, SUDAH DITERIMA', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: _belumDiterima,
                  child: const Text('Belum, ada kendala', style: TextStyle(color: Colors.grey)),
                ),
              ],
            ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Flexible(
          child: Text(value, textAlign: TextAlign.end, style: const TextStyle(fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}
