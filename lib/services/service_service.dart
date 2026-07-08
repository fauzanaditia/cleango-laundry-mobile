import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/service.dart';
import 'mock_data.dart';

/// Klien ServiceService yang terhubung ke API Laravel sungguhan untuk
/// pengambilan daftar paket layanan.
///
/// [baseUrl] default menunjuk ke 127.0.0.1 untuk pengujian di Flutter
/// web/desktop. Override lewat constructor saat menjalankan di Android
/// emulator (10.0.2.2), device fisik, iOS simulator, atau saat pengujian.
class ServiceService {
  ServiceService({String baseUrl = 'http://127.0.0.1:8000/api'}) : _baseUrl = baseUrl;

  final String _baseUrl;
  static const String _tokenKey = 'auth_token';
  static const Duration _timeout = Duration(seconds: 15);

  Future<List<Service>> getServices() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);

    if (token == null) {
      throw Exception('Anda belum login, silakan login terlebih dahulu');
    }

    http.Response response;
    try {
      response = await http.get(
        Uri.parse('$_baseUrl/services'),
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

    final decoded = _decodeRaw(response);

    if (response.statusCode == 200) {
      return _extractList(decoded)
          .whereType<Map<String, dynamic>>()
          .map(_serviceFromApiJson)
          .toList();
    }

    final errorBody = decoded is Map<String, dynamic> ? decoded : <String, dynamic>{};
    throw _errorFor(response.statusCode, errorBody);
  }

  /// Masih memakai data tiruan (belum ada endpoint tambah paket di API).
  Future<Service> createService({
    required String name,
    required double price,
    required int duration,
    String? description,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final now = DateTime.now();
    final service = Service(
      id: MockData.nextServiceId++,
      namaLayanan: name,
      hargaPerKg: price,
      estimasiHari: duration,
      deskripsi: description,
      createdAt: now,
      updatedAt: now,
    );

    MockData.services.add(service);
    return service;
  }

  dynamic _decodeRaw(http.Response response) {
    if (response.body.isEmpty) return null;
    try {
      return jsonDecode(response.body);
    } catch (_) {
      return null;
    }
  }

  /// Daftar paket bisa dikirim sebagai array JSON polos, atau dibungkus
  /// dalam `{ "data": [...] }` (pola umum Laravel API Resource).
  List<dynamic> _extractList(dynamic decoded) {
    if (decoded is List) return decoded;
    if (decoded is Map<String, dynamic> && decoded['data'] is List) {
      return decoded['data'] as List;
    }
    return const [];
  }

  Service _serviceFromApiJson(Map<String, dynamic> json) {
    final now = DateTime.now();
    return Service(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}') ?? 0,
      namaLayanan: json['nama_layanan']?.toString() ?? '',
      // harga_per_kg dikirim API sebagai string, mis. "7000.00".
      hargaPerKg: _asDouble(json['harga_per_kg']),
      estimasiHari: _asInt(json['estimasi_hari']),
      deskripsi: json['deskripsi']?.toString(),
      createdAt: _parseDate(json['created_at']) ?? now,
      updatedAt: _parseDate(json['updated_at']) ?? now,
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

  DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
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
