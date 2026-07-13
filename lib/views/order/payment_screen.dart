import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/payment_controller.dart';
import '../../models/payment.dart';
import 'order_draft.dart';
import 'order_success_screen.dart';
import 'payment_confirmation_screen.dart';

const _metodeLabels = {
  PaymentMethod.cash: 'Tunai',
  PaymentMethod.qris: 'QRIS',
};

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({
    super.key,
    required this.orderId,
    required this.kodeOrder,
    required this.tanggalOrder,
    required this.estimasiSelesai,
    required this.totalBayar,
  });

  final int orderId;
  final String kodeOrder;
  final DateTime tanggalOrder;
  final DateTime estimasiSelesai;
  final double totalBayar;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  PaymentMethod _metode = PaymentMethod.cash;

  Future<void> _bayarSekarang() async {
    final paymentController = context.read<PaymentController>();

    final success = await paymentController.createPayment(
      orderId: widget.orderId,
      metode: _metode,
    );

    if (!mounted) return;

    if (success) {
      if (_metode == PaymentMethod.cash) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => OrderSuccessScreen(
              kodeOrder: widget.kodeOrder,
              tanggalOrder: widget.tanggalOrder,
              estimasiSelesai: widget.estimasiSelesai,
            ),
          ),
          (route) => route.isFirst,
        );
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => PaymentConfirmationScreen(
              orderId: widget.orderId,
              kodeOrder: widget.kodeOrder,
              tanggalOrder: widget.tanggalOrder,
              estimasiSelesai: widget.estimasiSelesai,
              metode: _metodeLabels[_metode]!,
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(paymentController.errorMessage ?? 'Pembayaran gagal')),
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
        title: const Text('Pembayaran'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Total Pembayaran', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 4),
          Text(
            formatRupiah(widget.totalBayar),
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          const Text('Metode Pembayaran', style: TextStyle(fontWeight: FontWeight.w600)),
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: PaymentMethod.values
                  .map(
                    (metode) => RadioListTile<PaymentMethod>(
                      value: metode,
                      groupValue: _metode,
                      onChanged: (value) {
                        if (value != null) setState(() => _metode = value);
                      },
                      title: Text(_metodeLabels[metode]!),
                      activeColor: const Color(0xFF2E6BE6),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 28),
          ElevatedButton(
            onPressed: paymentController.isLoading ? null : _bayarSekarang,
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
                : const Text('BAYAR SEKARANG', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
