import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/service_controller.dart';
import '../../models/service.dart';
import 'order_detail_screen.dart';
import 'order_draft.dart';

class ChoosePackageScreen extends StatefulWidget {
  const ChoosePackageScreen({super.key, required this.draft});

  final OrderDraft draft;

  @override
  State<ChoosePackageScreen> createState() => _ChoosePackageScreenState();
}

class _ChoosePackageScreenState extends State<ChoosePackageScreen> {
  Service? _selectedService;
  late double _berat;

  @override
  void initState() {
    super.initState();
    _berat = widget.draft.berat;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final serviceController = context.read<ServiceController>();
      await serviceController.loadServices();
      if (!mounted) return;
      setState(() {
        _selectedService = widget.draft.service ??
            (serviceController.services.isNotEmpty
                ? serviceController.services.first
                : null);
      });
    });
  }

  void _ubahBerat(double delta) {
    setState(() {
      final next = _berat + delta;
      if (next >= 1) _berat = next;
    });
  }

  void _lanjut() {
    if (_selectedService == null) return;

    widget.draft.service = _selectedService;
    widget.draft.berat = _berat;

    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => OrderDetailScreen(draft: widget.draft)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final serviceController = context.watch<ServiceController>();
    final subtotal = (_selectedService?.price ?? 0) * _berat;
    final estimasiLabel = _selectedService != null
        ? formatDurationLabel(_selectedService!.duration)
        : '-';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF14224D),
        title: const Text('Pilih Paket'),
      ),
      body: serviceController.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                ...serviceController.services.map(
                  (service) => _PackageCard(
                    service: service,
                    selected: _selectedService?.id == service.id,
                    onTap: () => setState(() => _selectedService = service),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Berat Cucian', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () => _ubahBerat(-1),
                        icon: const Icon(Icons.remove_circle_outline),
                        color: const Color(0xFF2E6BE6),
                      ),
                      SizedBox(
                        width: 80,
                        child: Text(
                          '${_berat.toStringAsFixed(0)} Kg',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        onPressed: () => _ubahBerat(1),
                        icon: const Icon(Icons.add_circle_outline),
                        color: const Color(0xFF2E6BE6),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _SummaryRow(label: 'Estimasi', value: '$estimasiLabel Selesai'),
                      const Divider(height: 20),
                      _SummaryRow(
                        label: 'Total Harga',
                        value: formatRupiah(subtotal),
                        bold: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                ElevatedButton(
                  onPressed: _selectedService == null ? null : _lanjut,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E6BE6),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    minimumSize: const Size.fromHeight(0),
                  ),
                  child: const Text('LANJUT', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
    );
  }
}

class _PackageCard extends StatelessWidget {
  const _PackageCard({
    required this.service,
    required this.selected,
    required this.onTap,
  });

  final Service service;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? const Color(0xFF2E6BE6) : const Color(0xFFE0E3EB),
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Radio<bool>(
              value: true,
              groupValue: selected ? true : null,
              onChanged: (_) => onTap(),
              activeColor: const Color(0xFF2E6BE6),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${formatDurationLabel(service.duration)} Selesai',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            Text(
              '${formatRupiah(service.price)}/Kg',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.bold = false,
  });

  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      fontSize: bold ? 16 : 14,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style.copyWith(color: bold ? null : Colors.grey)),
        Text(value, style: style),
      ],
    );
  }
}
