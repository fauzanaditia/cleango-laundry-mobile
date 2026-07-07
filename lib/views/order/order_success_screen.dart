import 'package:flutter/material.dart';

import 'order_draft.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({
    super.key,
    required this.kodeOrder,
    required this.tanggalOrder,
    required this.estimasiSelesai,
  });

  final String kodeOrder;
  final DateTime tanggalOrder;
  final DateTime estimasiSelesai;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: const BoxDecoration(
                  color: Color(0xFFE7F8EE),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Color(0xFF34C759), size: 56),
              ),
              const SizedBox(height: 24),
              const Text(
                'Order Berhasil!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text('Kode Order Anda', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F6FA),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE0E3EB)),
                ),
                child: Text(
                  kodeOrder,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              Text('Tanggal Order: ${formatTanggalIndo(tanggalOrder)}'),
              const SizedBox(height: 4),
              Text('Estimasi Selesai: ${formatTanggalIndo(estimasiSelesai)}'),
              const SizedBox(height: 20),
              const Text(
                'Terima kasih telah menggunakan layanan kami.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E6BE6),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('LIHAT ORDER SAYA', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
