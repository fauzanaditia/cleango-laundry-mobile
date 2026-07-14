import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/order_controller.dart';
import '../../models/laundry_status_log.dart';
import '../../models/order.dart';
import 'order_draft.dart';
import 'ready_for_pickup_screen.dart';

class StatusOrderScreen extends StatefulWidget {
  const StatusOrderScreen({super.key, required this.orderId});

  final int orderId;

  @override
  State<StatusOrderScreen> createState() => _StatusOrderScreenState();
}

class _StatusOrderScreenState extends State<StatusOrderScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderController>().loadOrderDetail(widget.orderId);
    });
  }

  LaundryStatusLog? _logFor(List<LaundryStatusLog> logs, OrderStatus status) {
    for (final log in logs) {
      if (log.status == status) return log;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final orderController = context.watch<OrderController>();
    final detail = orderController.orderDetail;
    final loadingDifferentOrder = detail == null || detail.order.id != widget.orderId;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF14224D),
        title: const Text('Status Order'),
      ),
      body: (orderController.isLoading || loadingDifferentOrder)
          ? (orderController.errorMessage != null
              ? Center(child: Text(orderController.errorMessage!))
              : const Center(child: CircularProgressIndicator()))
          : _buildBody(context, detail.order, detail.statusLogs),
    );
  }

  Widget _buildBody(BuildContext context, Order order, List<LaundryStatusLog> logs) {
    final currentIndex = orderProcessStages.indexOf(order.status);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(order.kodeOrder, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 20),
        for (var i = 0; i < orderProcessStages.length; i++)
          _TimelineStep(
            label: orderStatusLabel(orderProcessStages[i]),
            timestamp: _logFor(logs, orderProcessStages[i])?.createdAt,
            keterangan: _logFor(logs, orderProcessStages[i])?.keterangan,
            state: i < currentIndex
                ? _StepState.completed
                : i == currentIndex
                    ? _StepState.current
                    : _StepState.upcoming,
            isLast: i == orderProcessStages.length - 1,
          ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF1FD),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            order.status == OrderStatus.diambil
                ? 'Pesanan Anda telah diambil/diterima. Terima kasih!'
                : order.status == OrderStatus.selesai
                    ? 'Pesanan Anda telah selesai! Siap diambil/diantar.'
                    : 'Pesanan Anda sedang dalam tahap: ${orderStatusLabel(order.status)}.',
            style: const TextStyle(color: Color(0xFF14224D)),
          ),
        ),
        if (order.status == OrderStatus.selesai) ...[
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ReadyForPickupScreen(orderId: order.id),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E6BE6),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              minimumSize: const Size.fromHeight(0),
            ),
            child: const Text('KONFIRMASI', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ],
    );
  }
}

enum _StepState { completed, current, upcoming }

class _TimelineStep extends StatelessWidget {
  const _TimelineStep({
    required this.label,
    required this.timestamp,
    this.keterangan,
    required this.state,
    required this.isLast,
  });

  final String label;
  final DateTime? timestamp;
  final String? keterangan;
  final _StepState state;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final Color indicatorColor = switch (state) {
      _StepState.completed => const Color(0xFF34C759),
      _StepState.current => const Color(0xFF2E6BE6),
      _StepState.upcoming => const Color(0xFFBFC5D2),
    };

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: state == _StepState.upcoming ? Colors.white : indicatorColor,
                  border: Border.all(color: indicatorColor, width: 2),
                ),
                child: state == _StepState.completed
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : null,
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: state == _StepState.completed
                        ? const Color(0xFF34C759)
                        : const Color(0xFFE0E3EB),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: state == _StepState.upcoming ? FontWeight.normal : FontWeight.bold,
                      color: state == _StepState.upcoming ? Colors.grey : const Color(0xFF14224D),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    timestamp != null
                        ? formatTanggalWaktuIndo(timestamp!)
                        : state == _StepState.upcoming
                            ? 'Menunggu'
                            : 'Sudah dilewati',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  if (keterangan != null && keterangan!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      keterangan!,
                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
