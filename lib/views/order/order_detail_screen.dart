import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/order_controller.dart';
import '../../services/order_service.dart';
import 'order_draft.dart';
import 'payment_screen.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({super.key, required this.draft});

  final OrderDraft draft;

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  Future<void> _lanjutKePembayaran() async {
    final draft = widget.draft;
    final orderController = context.read<OrderController>();
    final authController = context.read<AuthController>();
    final userId = authController.currentUser?.id;

    if (userId == null || draft.service == null) return;

    final order = await orderController.createOrder(
      userId: userId,
      pickupType: draft.pickupType,
      catatan: draft.catatan,
      items: [
        OrderItemInput(
          serviceId: draft.service!.id,
          berat: draft.berat,
          qty: 1,
          harga: draft.hargaPerKg,
        ),
      ],
    );

    if (!mounted) return;

    if (order != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => PaymentScreen(
            orderId: order.id,
            kodeOrder: order.kodeOrder,
            tanggalOrder: draft.tanggalOrder,
            estimasiSelesai: draft.estimasiSelesai,
            totalBayar: draft.totalBayar,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(orderController.errorMessage ?? 'Gagal membuat order')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final draft = widget.draft;
    final orderController = context.watch<OrderController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF14224D),
        title: const Text('Detail Order'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Ringkasan Order', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                _Row('Layanan', draft.layanan),
                const SizedBox(height: 10),
                _Row('Paket', '${draft.service?.namaLayanan ?? '-'} (${draft.service != null ? formatDurationLabel(draft.service!.estimasiHari) : '-'})'),
                const SizedBox(height: 10),
                _Row('Berat', '${draft.berat.toStringAsFixed(0)} Kg'),
                const SizedBox(height: 10),
                _Row('Tanggal Order', formatTanggalIndo(draft.tanggalOrder)),
                const SizedBox(height: 10),
                _Row('Estimasi Selesai', formatTanggalIndo(draft.estimasiSelesai)),
                const SizedBox(height: 10),
                _Row('Catatan', draft.catatan ?? '-'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Rincian Biaya', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                _Row('Harga / Kg', formatRupiah(draft.hargaPerKg)),
                const SizedBox(height: 10),
                _Row('Berat', '${draft.berat.toStringAsFixed(0)} Kg'),
                const SizedBox(height: 10),
                _Row('Subtotal', formatRupiah(draft.subtotal)),
                const SizedBox(height: 10),
                _Row('Antar Jemput', formatRupiah(draft.biayaAntarJemput)),
                const Divider(height: 24),
                _Row('Total Bayar', formatRupiah(draft.totalBayar), bold: true),
              ],
            ),
          ),
          const SizedBox(height: 28),
          ElevatedButton(
            onPressed: orderController.isLoading ? null : _lanjutKePembayaran,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E6BE6),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              minimumSize: const Size.fromHeight(0),
            ),
            child: orderController.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Text('LANJUT KE PEMBAYARAN', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value, {this.bold = false});

  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: bold ? null : Colors.grey, fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.w600, fontSize: bold ? 16 : 14),
          ),
        ),
      ],
    );
  }
}
