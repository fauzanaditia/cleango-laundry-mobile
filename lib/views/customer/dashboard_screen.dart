import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/dashboard_controller.dart';
import '../order/create_order_screen.dart';
import '../order/order_history_screen.dart';
import '../order/status_order_list_screen.dart';
import 'profile_screen.dart';
import 'widgets/customer_bottom_nav.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardController>().loadDashboardSummary();
    });
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature akan segera hadir')),
    );
  }

  void _openStatusOrder() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const StatusOrderListScreen()),
    );
  }

  void _onBottomNavTap(int index) {
    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const CreateOrderScreen()),
        );
        break;
      case 2:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const OrderHistoryScreen()),
        );
        break;
      case 3:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ProfileScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();
    final dashboardController = context.watch<DashboardController>();
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF14224D),
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => _showComingSoon('Notifikasi'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => dashboardController.loadDashboardSummary(),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Halo, ${authController.currentUser?.name.split(' ').first ?? ''} \u{1F44B}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Selamat datang di CleanGo Laundry',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            if (dashboardController.isLoading)
              const Center(child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: CircularProgressIndicator(),
              ))
            else if (dashboardController.errorMessage != null)
              Center(
                child: Column(
                  children: [
                    Text(dashboardController.errorMessage!,
                        style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => dashboardController.loadDashboardSummary(),
                      child: const Text('Coba lagi'),
                    ),
                  ],
                ),
              )
            else
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.5,
                children: [
                  _SummaryCard(
                    value: '${dashboardController.summary?.orderBaru ?? 0}',
                    label: 'Order Baru',
                    icon: Icons.add_box_outlined,
                    color: const Color(0xFF2E6BE6),
                  ),
                  _SummaryCard(
                    value: '${dashboardController.summary?.proses ?? 0}',
                    label: 'Proses',
                    icon: Icons.local_laundry_service_outlined,
                    color: const Color(0xFFF5A623),
                  ),
                  _SummaryCard(
                    value: '${dashboardController.summary?.selesai ?? 0}',
                    label: 'Selesai',
                    icon: Icons.check_circle_outline,
                    color: const Color(0xFF34C759),
                  ),
                  _SummaryCard(
                    value: currencyFormat.format(
                      dashboardController.summary?.totalPengeluaran ?? 0,
                    ),
                    label: 'Total Pengeluaran',
                    icon: Icons.account_balance_wallet_outlined,
                    color: const Color(0xFF8E44AD),
                    valueFontSize: 16,
                  ),
                ],
              ),
            const SizedBox(height: 28),
            const Text(
              'Menu Cepat',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _QuickMenuItem(
                  icon: Icons.add_shopping_cart_outlined,
                  label: 'Buat Order',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const CreateOrderScreen()),
                  ),
                ),
                _QuickMenuItem(
                  icon: Icons.history_outlined,
                  label: 'Riwayat',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const OrderHistoryScreen()),
                  ),
                ),
                _QuickMenuItem(
                  icon: Icons.track_changes_outlined,
                  label: 'Status Order',
                  onTap: _openStatusOrder,
                ),
                _QuickMenuItem(
                  icon: Icons.person_outline,
                  label: 'Profil',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ProfileScreen()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [Color(0xFF2E6BE6), Color(0xFF1B3F8F)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.card_giftcard, color: Colors.white, size: 36),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Promo Spesial',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Diskon 10% untuk order pertama!',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomerBottomNav(currentIndex: 0, onTap: _onBottomNavTap),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
    this.valueFontSize = 22,
  });

  final String value;
  final String label;
  final IconData icon;
  final Color color;
  final double valueFontSize;

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
            style: TextStyle(
              fontSize: valueFontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF14224D),
            ),
          ),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}

class _QuickMenuItem extends StatelessWidget {
  const _QuickMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF1FD),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: const Color(0xFF2E6BE6)),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 11), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
