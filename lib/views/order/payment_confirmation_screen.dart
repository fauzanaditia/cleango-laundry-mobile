import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/payment_controller.dart';
import 'order_success_screen.dart';

class PaymentConfirmationScreen extends StatelessWidget {
  const PaymentConfirmationScreen({
    super.key,
    required this.orderId,
    required this.kodeOrder,
    required this.tanggalOrder,
    required this.estimasiSelesai,
    required this.metode,
    this.baseUrl = 'http://127.0.0.1:8000',
  });

  final int orderId;
  final String kodeOrder;
  final DateTime tanggalOrder;
  final DateTime estimasiSelesai;
  final String metode;

  /// [baseUrl] default menunjuk ke 127.0.0.1 untuk pengujian di Flutter
  /// web/desktop, sama seperti pola baseUrl di service lain (mis.
  /// PaymentService). Override lewat constructor saat menjalankan di
  /// Android emulator (10.0.2.2), device fisik, iOS simulator, atau saat
  /// pengujian.
  final String baseUrl;

  static const _instruksi = 'Scan QR code berikut untuk menyelesaikan pembayaran.';

  Future<void> _sayaSudahBayar(BuildContext context) async {
    final paymentController = context.read<PaymentController>();
    final success = await paymentController.confirmPayment(orderId);

    if (!context.mounted) return;

    if (success) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => OrderSuccessScreen(
            kodeOrder: kodeOrder,
            tanggalOrder: tanggalOrder,
            estimasiSelesai: estimasiSelesai,
          ),
        ),
        (route) => route.isFirst,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(paymentController.errorMessage ?? 'Konfirmasi pembayaran gagal')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final paymentController = context.watch<PaymentController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF14224D),
        title: const Text('Menunggu Konfirmasi Pembayaran'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE0E3EB)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  '$baseUrl/api/assets/qris',
                  width: 140,
                  height: 140,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.qr_code_2,
                    size: 72,
                    color: Color(0xFF2E6BE6),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              metode,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _instruksi,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 28),
          ElevatedButton(
            onPressed: paymentController.isLoading ? null : () => _sayaSudahBayar(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E6BE6),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              minimumSize: const Size.fromHeight(0),
            ),
            child: paymentController.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Text('SAYA SUDAH BAYAR', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
