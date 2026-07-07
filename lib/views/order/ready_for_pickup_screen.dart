import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/order_controller.dart';
import '../../models/order.dart';
import 'pickup_confirmation_screen.dart';

class ReadyForPickupScreen extends StatefulWidget {
  const ReadyForPickupScreen({super.key, required this.orderId});

  final int orderId;

  @override
  State<ReadyForPickupScreen> createState() => _ReadyForPickupScreenState();
}

class _ReadyForPickupScreenState extends State<ReadyForPickupScreen> {
  PickupType? _pickupType;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final orderController = context.read<OrderController>();
      await orderController.loadOrderDetail(widget.orderId);
      if (!mounted) return;
      setState(() {
        _pickupType = orderController.orderDetail?.order.pickupType ?? PickupType.ambilDiStore;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderController = context.watch<OrderController>();
    final loading = orderController.isLoading || _pickupType == null;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF14224D),
        title: const Text('Siap Diambil / Diantar'),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const SizedBox(height: 12),
                Center(
                  child: Container(
                    width: 96,
                    height: 96,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEAF1FD),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.local_shipping_outlined, color: Color(0xFF2E6BE6), size: 48),
                  ),
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Text('Pesanan Siap!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 8),
                const Center(
                  child: Text(
                    'Pesanan Anda sudah selesai dan siap diambil/diantar.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 28),
                const Text('Pilih Opsi', style: TextStyle(fontWeight: FontWeight.w600)),
                Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      RadioListTile<PickupType>(
                        value: PickupType.ambilDiStore,
                        groupValue: _pickupType,
                        onChanged: (value) => setState(() => _pickupType = value),
                        title: const Text('Ambil di Store'),
                        activeColor: const Color(0xFF2E6BE6),
                      ),
                      RadioListTile<PickupType>(
                        value: PickupType.antarKeAlamat,
                        groupValue: _pickupType,
                        onChanged: (value) => setState(() => _pickupType = value),
                        title: const Text('Antar ke Alamat'),
                        activeColor: const Color(0xFF2E6BE6),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PickupConfirmationScreen(orderId: widget.orderId),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E6BE6),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    minimumSize: const Size.fromHeight(0),
                  ),
                  child: const Text('KONFIRMASI', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
    );
  }
}
