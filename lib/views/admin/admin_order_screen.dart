import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/order_controller.dart';
import '../../models/order.dart';
import '../order/order_draft.dart';
import 'widgets/admin_bottom_nav.dart';

const _tabLabels = ['Semua', 'Baru', 'Proses', 'Selesai'];

const _prosesStatuses = [
  OrderStatus.diterima,
  OrderStatus.dicuci,
  OrderStatus.dikeringkan,
  OrderStatus.disetrika,
  OrderStatus.qualityCheck,
];

class AdminOrderScreen extends StatefulWidget {
  const AdminOrderScreen({super.key});

  @override
  State<AdminOrderScreen> createState() => _AdminOrderScreenState();
}

class _AdminOrderScreenState extends State<AdminOrderScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderController>().loadOrders();
    });
  }

  List<Order> _filter(List<Order> orders, int tabIndex) {
    switch (tabIndex) {
      case 1:
        return orders.where((o) => o.status == OrderStatus.baru).toList();
      case 2:
        return orders.where((o) => _prosesStatuses.contains(o.status)).toList();
      case 3:
        return orders.where((o) => o.status == OrderStatus.selesai).toList();
      default:
        return orders;
    }
  }

  void _onBottomNavTap(int index) {
    if (index == 3) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final orderController = context.watch<OrderController>();

    return DefaultTabController(
      length: _tabLabels.length,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6FA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: const Color(0xFF14224D),
          title: const Text('Data Order'),
          bottom: TabBar(
            labelColor: const Color(0xFF2E6BE6),
            unselectedLabelColor: Colors.grey,
            indicatorColor: const Color(0xFF2E6BE6),
            tabs: _tabLabels.map((label) => Tab(text: label)).toList(),
          ),
        ),
        body: orderController.isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: List.generate(_tabLabels.length, (tabIndex) {
                  final filtered = _filter(orderController.orders, tabIndex);
                  if (filtered.isEmpty) {
                    return const Center(
                      child: Text('Tidak ada order', style: TextStyle(color: Colors.grey)),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final order = filtered[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(order.kodeOrder, style: const TextStyle(fontWeight: FontWeight.bold)),
                                _StatusPill(status: order.status),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              orderController.customerName(order.userId),
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              formatTanggalWaktuIndo(order.tanggalOrder),
                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                            const SizedBox(height: 4),
                            Text(formatRupiah(order.totalHarga), style: const TextStyle(fontWeight: FontWeight.w600)),
                          ],
                        ),
                      );
                    },
                  );
                }),
              ),
        bottomNavigationBar: AdminBottomNav(currentIndex: 3, onTap: _onBottomNavTap),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final color = orderStatusBucketColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        orderStatusLabel(status),
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }
}
