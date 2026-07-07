import 'package:flutter/material.dart';

class CleanGoLogo extends StatelessWidget {
  const CleanGoLogo({super.key, this.size = 72});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFF2E6BE6), Color(0xFF1B3F8F)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Icon(
            Icons.local_laundry_service_rounded,
            color: Colors.white,
            size: size * 0.5,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'CleanGo',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF14224D),
          ),
        ),
        const Text(
          'Laundry',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2E6BE6),
          ),
        ),
      ],
    );
  }
}
