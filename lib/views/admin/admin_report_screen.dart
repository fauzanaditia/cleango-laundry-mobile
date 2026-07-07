import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/report_controller.dart';
import '../order/order_draft.dart';

const _periodeOptions = [
  'Mei 2026',
  'Juni 2026',
  'Juli 2026',
];

class AdminReportScreen extends StatefulWidget {
  const AdminReportScreen({super.key});

  @override
  State<AdminReportScreen> createState() => _AdminReportScreenState();
}

class _AdminReportScreenState extends State<AdminReportScreen> {
  String _periode = _periodeOptions.last;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReportController>().loadLaporan(_periode);
    });
  }

  Future<void> _download() async {
    final reportController = context.read<ReportController>();
    final success = await reportController.downloadLaporan(_periode);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Laporan berhasil diunduh: ${reportController.lastDownloadedFileName}'
              : (reportController.errorMessage ?? 'Gagal mengunduh laporan'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reportController = context.watch<ReportController>();
    final summary = reportController.summary;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF14224D),
        title: const Text('Laporan'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Periode', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE0E3EB)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _periode,
                isExpanded: true,
                items: _periodeOptions
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _periode = value);
                  context.read<ReportController>().loadLaporan(value);
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (reportController.isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: CircularProgressIndicator(),
              ),
            )
          else if (summary != null) ...[
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
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _StatBox(label: 'Total Order', value: '${summary.totalOrder}'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatBox(label: 'Order Selesai', value: '${summary.orderSelesai}'),
                ),
              ],
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: reportController.isDownloading ? null : _download,
              icon: reportController.isDownloading
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.download_outlined),
              label: const Text('Download Laporan (PDF)', style: TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E6BE6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                minimumSize: const Size.fromHeight(0),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}
