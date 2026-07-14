import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/order_controller.dart';
import '../../controllers/service_controller.dart';
import '../../models/order.dart';
import '../../models/service.dart';
import '../../services/order_service.dart';
import '../customer/profile_screen.dart';
import '../customer/widgets/customer_bottom_nav.dart';
import '../customer/widgets/order_status_badge.dart';
import 'create_order_screen.dart';
import 'order_draft.dart';
import 'status_order_screen.dart';

class OrderHistoryDetailScreen extends StatefulWidget {
  const OrderHistoryDetailScreen({super.key, required this.orderId});

  final int orderId;

  @override
  State<OrderHistoryDetailScreen> createState() =>
      _OrderHistoryDetailScreenState();
}

class _OrderHistoryDetailScreenState extends State<OrderHistoryDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderController>().loadOrderDetail(widget.orderId);
      context.read<ServiceController>().loadServices();
    });
  }

  void _onBottomNavTap(int index) {
    if (index == 2) return;
    Navigator.of(context).popUntil((route) => route.isFirst);
    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const CreateOrderScreen()));
        break;
      case 3:
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const ProfileScreen()));
        break;
    }
  }

  Service? _findService(List<Service> services, int serviceId) {
    for (final s in services) {
      if (s.id == serviceId) return s;
    }
    return null;
  }

  DateTime? _tanggalSelesai(OrderController orderController) {
    final logs = orderController.orderDetail?.statusLogs ?? [];
    for (final log in logs) {
      if (log.status == OrderStatus.selesai) return log.createdAt;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final orderController = context.watch<OrderController>();
    final serviceController = context.watch<ServiceController>();
    final detail = orderController.orderDetail;
    final loading =
        orderController.isLoading ||
        detail == null ||
        detail.order.id != widget.orderId;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF14224D),
        title: const Text('Detail Riwayat'),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : _buildBody(
              context,
              detail,
              orderController,
              serviceController.services,
            ),
      bottomNavigationBar: CustomerBottomNav(
        currentIndex: 2,
        onTap: _onBottomNavTap,
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    OrderDetail detail,
    OrderController orderController,
    List<Service> services,
  ) {
    final order = detail.order;
    final tanggalSelesai = _tanggalSelesai(orderController);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              order.kodeOrder,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            OrderStatusBadge(status: order.status),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              for (final item in detail.items) ...[
                _Row(
                  _findService(services, item.serviceId)?.namaLayanan ??
                      'Paket',
                  '${item.berat.toStringAsFixed(0)} Kg x ${formatRupiah(item.harga)}',
                ),
                const SizedBox(height: 10),
              ],
              _Row('Tanggal Order', formatTanggalWaktuIndo(order.tanggalOrder)),
              const SizedBox(height: 10),
              _Row(
                'Tanggal Selesai',
                tanggalSelesai != null
                    ? formatTanggalWaktuIndo(tanggalSelesai)
                    : '-',
              ),
              const SizedBox(height: 10),
              _Row(
                'Metode Pengambilan',
                order.pickupType == PickupType.antarKeAlamat
                    ? 'Antar ke Alamat'
                    : 'Ambil di Store',
              ),
              const SizedBox(height: 10),
              _Row('Catatan', order.catatan ?? '-'),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Rincian Biaya',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              for (final item in detail.items) ...[
                _Row(
                  'Subtotal (${item.berat.toStringAsFixed(0)} Kg)',
                  formatRupiah(item.subtotal),
                ),
                const SizedBox(height: 10),
              ],
              const Divider(height: 12),
              _Row('Total Bayar', formatRupiah(order.totalHarga), bold: true),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Status Pembayaran',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: paymentStatusColor(
                        order.paymentStatus,
                      ).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      paymentStatusLabel(order.paymentStatus),
                      style: TextStyle(
                        color: paymentStatusColor(order.paymentStatus),
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
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const CreateOrderScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2E6BE6),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            minimumSize: const Size.fromHeight(0),
          ),
          child: const Text(
            'PESAN LAGI',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => StatusOrderScreen(orderId: order.id),
              ),
            );
          },
          child: const Text('Lihat Status Order'),
        ),
      ],
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
        Text(
          label,
          style: TextStyle(
            color: bold ? null : Colors.grey,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.w600,
              fontSize: bold ? 16 : 14,
            ),
          ),
        ),
      ],
    );
  }
}
