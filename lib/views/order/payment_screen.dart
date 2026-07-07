import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/payment_controller.dart';
import '../../models/payment.dart';
import 'order_draft.dart';
import 'order_success_screen.dart';

const _metodeLabels = {
  PaymentMethod.tunai: 'Tunai',
  PaymentMethod.transferBank: 'Transfer Bank',
  PaymentMethod.qris: 'QRIS',
  PaymentMethod.eWallet: 'E-Wallet',
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
  final _catatanController = TextEditingController();
  PaymentMethod _metode = PaymentMethod.tunai;

  @override
  void dispose() {
    _catatanController.dispose();
    super.dispose();
  }

  Future<void> _bayarSekarang() async {
    final paymentController = context.read<PaymentController>();

    final success = await paymentController.createPayment(
      orderId: widget.orderId,
      metode: _metode,
      jumlahBayar: widget.totalBayar,
      catatan: _catatanController.text.trim().isEmpty
          ? null
          : _catatanController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
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
          const SizedBox(height: 20),
          const Text('Catatan (Opsional)', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F6FA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE0E3EB)),
            ),
            child: TextField(
              controller: _catatanController,
              maxLines: 3,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Contoh: Bayar di tempat',
              ),
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
