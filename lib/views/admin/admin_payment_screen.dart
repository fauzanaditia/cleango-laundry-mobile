import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/order_controller.dart';
import '../../controllers/payment_controller.dart';
import '../../models/payment.dart';
import '../order/order_draft.dart';

const _tabLabels = ['Belum Lunas', 'Lunas'];

class AdminPaymentScreen extends StatefulWidget {
  const AdminPaymentScreen({super.key});

  @override
  State<AdminPaymentScreen> createState() => _AdminPaymentScreenState();
}

class _AdminPaymentScreenState extends State<AdminPaymentScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PaymentController>().loadPayments();
      context.read<OrderController>().loadOrders();
    });
  }

  List<Payment> _filter(List<Payment> payments, int tabIndex) {
    final status = tabIndex == 0 ? PaymentStatus.belumLunas : PaymentStatus.lunas;
    return payments.where((p) => p.status == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    final paymentController = context.watch<PaymentController>();
    final orderController = context.watch<OrderController>();

    return DefaultTabController(
      length: _tabLabels.length,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6FA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: const Color(0xFF14224D),
          title: const Text('Pembayaran'),
          bottom: TabBar(
            labelColor: const Color(0xFF2E6BE6),
            unselectedLabelColor: Colors.grey,
            indicatorColor: const Color(0xFF2E6BE6),
            tabs: _tabLabels.map((label) => Tab(text: label)).toList(),
          ),
        ),
        body: paymentController.isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: List.generate(_tabLabels.length, (tabIndex) {
                  final filtered = _filter(paymentController.payments, tabIndex);
                  if (filtered.isEmpty) {
                    return const Center(
                      child: Text('Tidak ada data pembayaran', style: TextStyle(color: Colors.grey)),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final payment = filtered[index];
                      final order = orderController.orders.where((o) => o.id == payment.orderId);
                      final kodeOrder = order.isNotEmpty ? order.first.kodeOrder : '-';
                      final customerName = order.isNotEmpty
                          ? orderController.customerName(order.first.userId)
                          : '-';
                      final lunas = payment.status == PaymentStatus.lunas;

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
                                Text(kodeOrder, style: const TextStyle(fontWeight: FontWeight.bold)),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: (lunas ? const Color(0xFF34C759) : const Color(0xFFF5A623))
                                        .withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    lunas ? 'Lunas' : 'Belum Lunas',
                                    style: TextStyle(
                                      color: lunas ? const Color(0xFF34C759) : const Color(0xFFF5A623),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(customerName, style: const TextStyle(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            Text(formatRupiah(payment.jumlahBayar),
                                style: const TextStyle(fontWeight: FontWeight.w600)),
                          ],
                        ),
                      );
                    },
                  );
                }),
              ),
      ),
    );
  }
}
