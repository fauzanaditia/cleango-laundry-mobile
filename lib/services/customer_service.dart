import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/customer.dart';
import 'mock_data.dart';

/// Klien CustomerService yang terhubung ke API Laravel sungguhan untuk
/// pengambilan daftar customer.
///
/// [baseUrl] default menunjuk ke 127.0.0.1 untuk pengujian di Flutter
/// web/desktop. Override lewat constructor saat menjalankan di Android
/// emulator (10.0.2.2), device fisik, iOS simulator, atau saat pengujian.
class CustomerService {
  CustomerService({String baseUrl = 'http://127.0.0.1:8000/api'}) : _baseUrl = baseUrl;

  final String _baseUrl;
  static const String _tokenKey = 'auth_token';
  static const Duration _timeout = Duration(seconds: 15);

  Future<List<Customer>> getCustomers({String? query}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);

    if (token == null) {
      throw Exception('Anda belum login, silakan login terlebih dahulu');
    }

    final trimmedQuery = query?.trim();
    final uri = Uri.parse('$_baseUrl/customers').replace(
      queryParameters: (trimmedQuery != null && trimmedQuery.isNotEmpty)
          ? {'search': trimmedQuery}
          : null,
    );

    http.Response response;
    try {
      response = await http.get(
        uri,
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
      final customers = _extractList(decoded)
          .whereType<Map<String, dynamic>>()
          .map(_customerFromApiJson)
          .toList();

      // Jaga-jaga bila API belum mendukung parameter pencarian di server.
      if (trimmedQuery == null || trimmedQuery.isEmpty) {
        return customers;
      }
      final lowerQuery = trimmedQuery.toLowerCase();
      return customers
          .where((c) =>
              c.name.toLowerCase().contains(lowerQuery) ||
              c.phone.toLowerCase().contains(lowerQuery))
          .toList();
    }

    final errorBody = decoded is Map<String, dynamic> ? decoded : <String, dynamic>{};
    throw _errorFor(response.statusCode, errorBody);
  }

  /// Masih memakai data tiruan (belum ada endpoint tambah customer di API).
  Future<Customer> createCustomer({
    required String name,
    required String phone,
    String? email,
    String? address,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final now = DateTime.now();
    final customer = Customer(
      id: MockData.nextCustomerId++,
      name: name,
      phone: phone,
      email: email,
      address: address,
      createdAt: now,
      updatedAt: now,
    );

    MockData.customers.add(customer);
    return customer;
  }

  dynamic _decodeRaw(http.Response response) {
    if (response.body.isEmpty) return null;
    try {
      return jsonDecode(response.body);
    } catch (_) {
      return null;
    }
  }

  /// Daftar customer bisa dikirim sebagai array JSON polos, atau dibungkus
  /// dalam `{ "data": [...] }` (pola umum Laravel API Resource).
  List<dynamic> _extractList(dynamic decoded) {
    if (decoded is List) return decoded;
    if (decoded is Map<String, dynamic> && decoded['data'] is List) {
      return decoded['data'] as List;
    }
    return const [];
  }

  Customer _customerFromApiJson(Map<String, dynamic> json) {
    final now = DateTime.now();
    return Customer(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}') ?? 0,
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      email: json['email']?.toString(),
      address: json['address']?.toString(),
      createdAt: _parseDate(json['created_at']) ?? now,
      updatedAt: _parseDate(json['updated_at']) ?? now,
    );
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
