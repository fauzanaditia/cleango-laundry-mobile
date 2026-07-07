import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/admin_auth_controller.dart';
import 'admin_login_screen.dart';
import 'admin_payment_screen.dart';
import 'admin_report_screen.dart';
import 'widgets/admin_bottom_nav.dart';

class AdminMoreScreen extends StatefulWidget {
  const AdminMoreScreen({super.key});

  @override
  State<AdminMoreScreen> createState() => _AdminMoreScreenState();
}

class _AdminMoreScreenState extends State<AdminMoreScreen> {
  void _onBottomNavTap(int index) {
    if (index == 4) return;
    Navigator.of(context).pop();
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Apakah Anda yakin ingin keluar dari Admin Panel?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    await context.read<AdminAuthController>().logout();

    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const AdminLoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF14224D),
        title: const Text('Lainnya'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _MenuTile(
            icon: Icons.payments_outlined,
            label: 'Pembayaran',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AdminPaymentScreen()),
            ),
          ),
          _MenuTile(
            icon: Icons.description_outlined,
            label: 'Laporan',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AdminReportScreen()),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _logout,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE74C3C),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('LOGOUT', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      bottomNavigationBar: AdminBottomNav(currentIndex: 4, onTap: _onBottomNavTap),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF2E6BE6)),
        title: Text(label),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
