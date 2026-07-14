import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/payment.dart';

/// Klien PaymentService, terhubung ke API Laravel sungguhan.
///
/// [baseUrl] default menunjuk ke 127.0.0.1 untuk pengujian di Flutter
/// web/desktop. Override lewat constructor saat menjalankan di Android
/// emulator (10.0.2.2), device fisik, iOS simulator, atau saat pengujian.
class PaymentService {
  PaymentService({String baseUrl = 'http://127.0.0.1:8000/api'}) : _baseUrl = baseUrl;

  final String _baseUrl;
  static const String _tokenKey = 'auth_token';
  static const Duration _timeout = Duration(seconds: 15);

  Future<Payment> createPayment({
    required int orderId,
    required PaymentMethod metode,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);

    if (token == null) {
      throw Exception('Anda belum login, silakan login terlebih dahulu');
    }

    http.Response response;
    try {
      response = await http
          .post(
            Uri.parse('$_baseUrl/orders/$orderId/payment'),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({'metode': metode.toJson()}),
          )
          .timeout(_timeout);
    } on TimeoutException {
      throw Exception('Waktu koneksi ke server habis, silakan coba lagi');
    } on http.ClientException {
      throw Exception('Tidak dapat terhubung ke server. Periksa koneksi internet Anda.');
    }

    final decoded = _decodeRaw(response);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Payment.fromJson(_extractObject(decoded));
    }

    if (response.statusCode == 404) {
      throw Exception('Order dengan id $orderId tidak ditemukan');
    }

    throw _errorFor(response.statusCode, decoded is Map<String, dynamic> ? decoded : {});
  }

  /// Konfirmasi dari pelanggan bahwa pembayaran (Transfer/QRIS/E-Wallet)
  /// sudah diselesaikan di sisi mereka.
  Future<Payment> confirmPayment(int orderId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);

    if (token == null) {
      throw Exception('Anda belum login, silakan login terlebih dahulu');
    }

    http.Response response;
    try {
      response = await http
          .patch(
            Uri.parse('$_baseUrl/orders/$orderId/payment/confirm'),
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(_timeout);
    } on TimeoutException {
      throw Exception('Waktu koneksi ke server habis, silakan coba lagi');
    } on http.ClientException {
      throw Exception('Tidak dapat terhubung ke server. Periksa koneksi internet Anda.');
    }

    final decoded = _decodeRaw(response);

    if (response.statusCode == 200) {
      return Payment.fromJson(_extractObject(decoded));
    }

    if (response.statusCode == 404) {
      throw Exception('Order dengan id $orderId tidak ditemukan');
    }

    throw _errorFor(response.statusCode, decoded is Map<String, dynamic> ? decoded : {});
  }

  Future<PaymentStatus> getPaymentStatus(int orderId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);

    if (token == null) {
      throw Exception('Anda belum login, silakan login terlebih dahulu');
    }

    http.Response response;
    try {
      response = await http
          .get(
            Uri.parse('$_baseUrl/orders/$orderId/payment'),
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(_timeout);
    } on TimeoutException {
      throw Exception('Waktu koneksi ke server habis, silakan coba lagi');
    } on http.ClientException {
      throw Exception('Tidak dapat terhubung ke server. Periksa koneksi internet Anda.');
    }

    final decoded = _decodeRaw(response);

    if (response.statusCode == 200) {
      return Payment.fromJson(_extractObject(decoded)).status;
    }

    if (response.statusCode == 404) {
      return PaymentStatus.pending;
    }

    throw _errorFor(response.statusCode, decoded is Map<String, dynamic> ? decoded : {});
  }

  dynamic _decodeRaw(http.Response response) {
    if (response.body.isEmpty) return null;
    try {
      return jsonDecode(response.body);
    } catch (_) {
      return null;
    }
  }

  /// Objek tunggal bisa dikirim polos atau dibungkus dalam
  /// `{ "data": {...} }` (pola umum Laravel API Resource).
  Map<String, dynamic> _extractObject(dynamic decoded) {
    if (decoded is Map<String, dynamic>) {
      final data = decoded['data'];
      if (data is Map<String, dynamic>) return data;
      return decoded;
    }
    return {};
  }

  Exception _errorFor(int statusCode, Map<String, dynamic> body) {
    return Exception(_messageFor(statusCode, body));
  }

  String _messageFor(int statusCode, Map<String, dynamic> body) {
    final errors = body['errors'];
    if (errors is Map) {
      final messages = <String>[];
      for (final value in errors.values) {
        if (value is List) {
          messages.addAll(value.map((e) => e.toString()));
        } else if (value != null) {
          messages.add(value.toString());
        }
      }
      if (messages.isNotEmpty) return messages.join('\n');
    }

    final message = body['message'];
    if (message is String && message.isNotEmpty) {
      return message;
    }

    switch (statusCode) {
      case 401:
        return 'Sesi Anda telah berakhir, silakan login kembali';
      case 422:
        return 'Data yang dikirim tidak valid';
      case 500:
        return 'Terjadi kesalahan pada server, silakan coba lagi nanti';
      default:
        return 'Terjadi kesalahan (kode $statusCode)';
    }
  }
}
