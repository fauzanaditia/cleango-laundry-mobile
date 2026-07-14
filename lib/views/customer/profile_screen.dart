import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth_controller.dart';
import '../auth/login_screen.dart';
import '../order/create_order_screen.dart';
import '../order/order_history_screen.dart';
import 'edit_profile_screen.dart';
import 'widgets/customer_bottom_nav.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature akan segera hadir')),
    );
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
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

    await context.read<AuthController>().logout();

    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  void _onBottomNavTap(int index) {
    if (index == 3) return;
    Navigator.of(context).popUntil((route) => route.isFirst);
    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CreateOrderScreen()));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const OrderHistoryScreen()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();
    final profile = authController.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF14224D),
        title: const Text('Profil Saya'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Color(0xFFEAF1FD),
                  child: Icon(Icons.person, size: 44, color: Color(0xFF2E6BE6)),
                ),
                const SizedBox(height: 12),
                Text(
                  profile?.name ?? '-',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(profile?.phone ?? '-', style: const TextStyle(color: Colors.grey)),
                Text(profile?.email ?? '-', style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(height: 28),
          _ProfileMenuTile(
            icon: Icons.location_on_outlined,
            label: 'Alamat Saya',
            onTap: () => _showComingSoon('Alamat Saya'),
          ),
          _ProfileMenuTile(
            icon: Icons.payment_outlined,
            label: 'Metode Pembayaran',
            onTap: () => _showComingSoon('Metode Pembayaran'),
          ),
          _ProfileMenuTile(
            icon: Icons.settings_outlined,
            label: 'Pengaturan Akun',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const EditProfileScreen()),
            ),
          ),
          _ProfileMenuTile(
            icon: Icons.help_outline,
            label: 'Bantuan',
            onTap: () => _showComingSoon('Bantuan'),
          ),
          _ProfileMenuTile(
            icon: Icons.info_outline,
            label: 'Tentang Aplikasi',
            onTap: () => _showComingSoon('Tentang Aplikasi'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: authController.isLoading ? null : _logout,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE74C3C),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: authController.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Text('LOGOUT', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      bottomNavigationBar: CustomerBottomNav(currentIndex: 3, onTap: _onBottomNavTap),
    );
  }
}

class _ProfileMenuTile extends StatelessWidget {
  const _ProfileMenuTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
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
