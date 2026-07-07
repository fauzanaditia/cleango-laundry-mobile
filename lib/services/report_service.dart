class LaporanSummary {
  final String periode;
  final double totalPendapatan;
  final int totalOrder;
  final int orderSelesai;

  LaporanSummary({
    required this.periode,
    required this.totalPendapatan,
    required this.totalOrder,
    required this.orderSelesai,
  });
}

class ReportService {
  Future<LaporanSummary> getLaporan(String periode) async {
    await Future.delayed(const Duration(milliseconds: 600));

    return LaporanSummary(
      periode: periode,
      totalPendapatan: 8750000,
      totalOrder: 100,
      orderSelesai: 45,
    );
  }

  /// Simulasi pembuatan file laporan. Tidak menghasilkan PDF sungguhan -
  /// hanya mengembalikan nama file setelah jeda singkat.
  Future<String> downloadLaporanPdf(String periode) async {
    await Future.delayed(const Duration(milliseconds: 1200));
    return 'laporan_${periode.replaceAll(' ', '_').toLowerCase()}.pdf';
  }
}
