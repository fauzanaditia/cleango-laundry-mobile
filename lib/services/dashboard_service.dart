import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DashboardSummary {
  final int orderBaru;
  final int proses;
  final int selesai;
  final double totalPengeluaran;

  DashboardSummary({
    required this.orderBaru,
    required this.proses,
    required this.selesai,
    required this.totalPengeluaran,
  });
}

/// Klien DashboardService yang terhubung ke API Laravel sungguhan.
///
/// [baseUrl] default menunjuk ke 127.0.0.1 untuk pengujian di Flutter
/// web/desktop. Override lewat constructor saat menjalankan di Android
/// emulator (10.0.2.2), device fisik, iOS simulator, atau saat pengujian.
class DashboardService {
  DashboardService({String baseUrl = 'http://127.0.0.1:8000/api'}) : _baseUrl = baseUrl;

  final String _baseUrl;
  static const String _tokenKey = 'auth_token';
  static const Duration _timeout = Duration(seconds: 15);

  Future<DashboardSummary> getDashboardSummary() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);

    if (token == null) {
      throw Exception('Anda belum login, silakan login terlebih dahulu');
    }

    http.Response response;
    try {
      response = await http.get(
        Uri.parse('$_baseUrl/dashboard'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(_timeout);
    } on TimeoutException {
      throw Exception('Waktu koneksi ke server habis, silakan coba lagi');
    } on http.ClientException {
      throw Exception('Tidak dapat terhubung ke server. Periksa koneksi internet Anda.');
    }

    final body = _decodeBody(response);

    if (response.statusCode == 200) {
      return _summaryFromApiJson(_extractData(body));
    }

    throw _errorFor(response.statusCode, body);
  }

  Map<String, dynamic> _decodeBody(http.Response response) {
    if (response.body.isEmpty) return {};
    try {
      final decoded = jsonDecode(response.body);
      return decoded is Map<String, dynamic> ? decoded : {};
    } catch (_) {
      return {};
    }
  }

  Map<String, dynamic> _extractData(Map<String, dynamic> body) {
    final data = body['data'];
    return data is Map<String, dynamic> ? data : body;
  }

  DashboardSummary _summaryFromApiJson(Map<String, dynamic> json) {
    return DashboardSummary(
      orderBaru: _asInt(json['order_baru']),
      proses: _asInt(json['proses']),
      selesai: _asInt(json['selesai']),
      totalPengeluaran: _asDouble(json['total_pengeluaran']),
    );
  }

  int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse('$value') ?? 0;
  }

  double _asDouble(dynamic value) {
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return double.tryParse('$value') ?? 0;
  }

  Exception _errorFor(int statusCode, Map<String, dynamic> body) {
    return Exception(_messageFor(statusCode, body));
  }

  String _messageFor(int statusCode, Map<String, dynamic> body) {
    final message = body['message'];
    if (message is String && message.isNotEmpty) {
      return message;
    }

    switch (statusCode) {
      case 401:
        return 'Sesi Anda telah berakhir, silakan login kembali';
      case 500:
        return 'Terjadi kesalahan pada server, silakan coba lagi nanti';
      default:
        return 'Terjadi kesalahan (kode $statusCode)';
    }
  }
}
