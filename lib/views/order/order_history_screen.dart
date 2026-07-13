import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/order_controller.dart';
import '../../models/order.dart';
import '../customer/profile_screen.dart';
import '../customer/widgets/customer_bottom_nav.dart';
import '../customer/widgets/order_status_badge.dart';
import 'create_order_screen.dart';
import 'order_draft.dart';
import 'order_history_detail_screen.dart';

const _tabLabels = ['Semua', 'Proses', 'Selesai', 'Dibatalkan'];

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
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
        return orders.where((o) => isOrderInProses(o.status)).toList();
      case 2:
        return orders
            .where((o) => o.status == OrderStatus.selesai || o.status == OrderStatus.diambil)
            .toList();
      case 3:
        // Backend belum punya status batal, tab ini akan selalu kosong untuk
        // sementara sampai status tersebut ditambahkan lagi.
        return const [];
      default:
        return orders;
    }
  }

  void _onBottomNavTap(int index) {
    if (index == 2) return;
    Navigator.of(context).popUntil((route) => route.isFirst);
    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CreateOrderScreen()));
        break;
      case 3:
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProfileScreen()));
        break;
    }
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
          title: const Text('Riwayat Order'),
          bottom: TabBar(
            labelColor: const Color(0xFF2E6BE6),
            unselectedLabelColor: Colors.grey,
            indicatorColor: const Color(0xFF2E6BE6),
            tabs: _tabLabels.map((label) => Tab(text: label)).toList(),
          ),
        ),
        body: orderController.isLoading
            ? const Center(child: CircularProgressIndicator())
            : orderController.errorMessage != null
                ? Center(child: Text(orderController.errorMessage!))
                : TabBarView(
                    children: List.generate(_tabLabels.length, (tabIndex) {
                      final filtered = _filter(orderController.orders, tabIndex);
                      if (filtered.isEmpty) {
                        return const Center(
                          child: Text('Belum ada order', style: TextStyle(color: Colors.grey)),
                        );
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) => _OrderCard(order: filtered[index]),
                      );
                    }),
                  ),
        bottomNavigationBar: CustomerBottomNav(currentIndex: 2, onTap: _onBottomNavTap),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => OrderHistoryDetailScreen(orderId: order.id)),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(order.kodeOrder, style: const TextStyle(fontWeight: FontWeight.bold)),
                OrderStatusBadge(status: order.status),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              formatTanggalWaktuIndo(order.tanggalOrder),
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              formatRupiah(order.totalHarga),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
