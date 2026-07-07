import 'package:flutter/material.dart';

class AdminBottomNav extends StatelessWidget {
  const AdminBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF2E6BE6),
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: 'Dashboard'),
        BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: 'Customer'),
        BottomNavigationBarItem(icon: Icon(Icons.local_laundry_service_outlined), label: 'Service'),
        BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), label: 'Order'),
        BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'Lainnya'),
      ],
    );
  }
}
