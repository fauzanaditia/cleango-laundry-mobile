import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/auth_controller.dart';
import 'controllers/dashboard_controller.dart';
import 'controllers/order_controller.dart';
import 'controllers/payment_controller.dart';
import 'controllers/service_controller.dart';
import 'views/auth/login_screen.dart';

void main() {
  runApp(const CleanGoApp());
}

class CleanGoApp extends StatelessWidget {
  const CleanGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => DashboardController()),
        ChangeNotifierProvider(create: (_) => ServiceController()),
        ChangeNotifierProvider(create: (_) => OrderController()),
        ChangeNotifierProvider(create: (_) => PaymentController()),
      ],
      child: MaterialApp(
        title: 'CleanGo Laundry',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E6BE6)),
          useMaterial3: true,
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
