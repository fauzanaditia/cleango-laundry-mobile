import 'package:flutter/foundation.dart';

import '../services/report_service.dart';

class ReportController extends ChangeNotifier {
  ReportController({ReportService? reportService})
      : _reportService = reportService ?? ReportService();

  final ReportService _reportService;

  bool isLoading = false;
  bool isDownloading = false;
  String? errorMessage;

  LaporanSummary? summary;
  String? lastDownloadedFileName;

  Future<void> loadLaporan(String periode) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      summary = await _reportService.getLaporan(periode);
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> downloadLaporan(String periode) async {
    isDownloading = true;
    errorMessage = null;
    notifyListeners();

    try {
      lastDownloadedFileName = await _reportService.downloadLaporanPdf(periode);
      isDownloading = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      isDownloading = false;
      notifyListeners();
      return false;
    }
  }
}
