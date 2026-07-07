class AdminDashboardSummary {
  final int totalCustomer;
  final int orderBaru;
  final int proses;
  final int selesai;
  final double totalPendapatan;

  AdminDashboardSummary({
    required this.totalCustomer,
    required this.orderBaru,
    required this.proses,
    required this.selesai,
    required this.totalPendapatan,
  });
}

class AdminDashboardService {
  Future<AdminDashboardSummary> getAdminDashboardSummary() async {
    await Future.delayed(const Duration(milliseconds: 600));

    return AdminDashboardSummary(
      totalCustomer: 25,
      orderBaru: 12,
      proses: 18,
      selesai: 45,
      totalPendapatan: 8750000,
    );
  }
}
