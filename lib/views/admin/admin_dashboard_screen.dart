import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/admin_dashboard_controller.dart';
import '../order/order_draft.dart';
import 'admin_customer_screen.dart';
import 'admin_more_screen.dart';
import 'admin_order_screen.dart';
import 'admin_service_screen.dart';
import 'widgets/admin_bottom_nav.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminDashboardController>().loadSummary();
    });
  }

  void _onBottomNavTap(int index) {
    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AdminCustomerScreen()));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AdminServiceScreen()));
        break;
      case 3:
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AdminOrderScreen()));
        break;
      case 4:
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AdminMoreScreen()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final adminDashboardController = context.watch<AdminDashboardController>();
    final summary = adminDashboardController.summary;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF14224D),
        title: const Text('Dashboard'),
      ),
      body: RefreshIndicator(
        onRefresh: () => adminDashboardController.loadSummary(),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Halo, Admin \u{1F44B}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text('Selamat datang kembali', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            if (adminDashboardController.isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (summary != null)
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.5,
                children: [
                  _StatCard(
                    value: '${summary.totalCustomer}',
                    label: 'Total Customer',
                    icon: Icons.people_outline,
                    color: const Color(0xFF2E6BE6),
                  ),
                  _StatCard(
                    value: '${summary.orderBaru}',
                    label: 'Order Baru',
                    icon: Icons.add_box_outlined,
                    color: const Color(0xFF8E44AD),
                  ),
                  _StatCard(
                    value: '${summary.proses}',
                    label: 'Proses',
                    icon: Icons.local_laundry_service_outlined,
                    color: const Color(0xFFF5A623),
                  ),
                  _StatCard(
                    value: '${summary.selesai}',
                    label: 'Selesai',
                    icon: Icons.check_circle_outline,
                    color: const Color(0xFF34C759),
                  ),
                ],
              ),
            const SizedBox(height: 12),
            if (summary != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2E6BE6), Color(0xFF1B3F8F)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Pendapatan', style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 6),
                    Text(
                      formatRupiah(summary.totalPendapatan),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: AdminBottomNav(currentIndex: 0, onTap: _onBottomNavTap),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  final String value;
  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF14224D)),
          ),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}
