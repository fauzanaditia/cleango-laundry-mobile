import 'package:flutter/material.dart';

import '../../models/order.dart';
import 'choose_package_screen.dart';
import 'order_draft.dart';

const _layananOptions = [
  'Cuci + Setrika',
  'Cuci Saja',
  'Setrika Saja',
  'Dry Clean',
];

const _jenisCucianOptions = [
  'Pakaian',
  'Selimut / Bed Cover',
  'Kain / Lainnya',
];

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({super.key});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final _catatanController = TextEditingController();

  String _layanan = _layananOptions.first;
  DateTime _tanggalOrder = DateTime.now();
  String _jenisCucian = _jenisCucianOptions.first;
  PickupType _pickupType = PickupType.ambilDiStore;

  @override
  void dispose() {
    _catatanController.dispose();
    super.dispose();
  }

  Future<void> _pickTanggal() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggalOrder,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 60)),
    );
    if (picked != null) {
      setState(() => _tanggalOrder = picked);
    }
  }

  void _lanjut() {
    final draft = OrderDraft(
      layanan: _layanan,
      tanggalOrder: _tanggalOrder,
      jenisCucian: _jenisCucian,
      catatan: _catatanController.text.trim().isEmpty
          ? null
          : _catatanController.text.trim(),
      pickupType: _pickupType,
    );

    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ChoosePackageScreen(draft: draft)),
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
        title: const Text('Buat Order'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Pilih Layanan', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          _FieldContainer(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _layanan,
                isExpanded: true,
                items: _layananOptions
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _layanan = value);
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Tanggal', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          InkWell(
            onTap: _pickTanggal,
            borderRadius: BorderRadius.circular(12),
            child: _FieldContainer(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(formatTanggalIndo(_tanggalOrder)),
                  const Icon(Icons.calendar_today_outlined, size: 18, color: Colors.grey),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Jenis Cucian', style: TextStyle(fontWeight: FontWeight.w600)),
          Column(
            children: _jenisCucianOptions
                .map(
                  (option) => RadioListTile<String>(
                    value: option,
                    groupValue: _jenisCucian,
                    onChanged: (value) {
                      if (value != null) setState(() => _jenisCucian = value);
                    },
                    title: Text(option),
                    contentPadding: EdgeInsets.zero,
                    activeColor: const Color(0xFF2E6BE6),
                    dense: true,
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          const Text('Metode Pengambilan', style: TextStyle(fontWeight: FontWeight.w600)),
          Column(
            children: [
              RadioListTile<PickupType>(
                value: PickupType.ambilDiStore,
                groupValue: _pickupType,
                onChanged: (value) {
                  if (value != null) setState(() => _pickupType = value);
                },
                title: const Text('Ambil di Store'),
                contentPadding: EdgeInsets.zero,
                activeColor: const Color(0xFF2E6BE6),
                dense: true,
              ),
              RadioListTile<PickupType>(
                value: PickupType.antarKeAlamat,
                groupValue: _pickupType,
                onChanged: (value) {
                  if (value != null) setState(() => _pickupType = value);
                },
                title: const Text('Antar ke Alamat'),
                subtitle: Text('Biaya tambahan ${formatRupiah(kBiayaAntarJemput)}'),
                contentPadding: EdgeInsets.zero,
                activeColor: const Color(0xFF2E6BE6),
                dense: true,
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text('Catatan (Opsional)', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          _FieldContainer(
            child: TextField(
              controller: _catatanController,
              maxLines: 3,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Contoh: Jangan gunakan pewangi',
              ),
            ),
          ),
          const SizedBox(height: 28),
          ElevatedButton(
            onPressed: _lanjut,
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

class _FieldContainer extends StatelessWidget {
  const _FieldContainer({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E3EB)),
      ),
      child: child,
    );
  }
}
