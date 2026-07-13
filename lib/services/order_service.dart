import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/laundry_status_log.dart';
import '../models/order.dart';
import '../models/order_item.dart';

/// Input for a single line item when creating a new order.
class OrderItemInput {
  final int serviceId;
  final double berat;
  final int qty;
  final double harga;

  OrderItemInput({
    required this.serviceId,
    required this.berat,
    required this.qty,
    required this.harga,
  });
}

class OrderDetail {
  final Order order;
  final List<OrderItem> items;
  final List<LaundryStatusLog> statusLogs;

  OrderDetail({
    required this.order,
    required this.items,
    required this.statusLogs,
  });
}

/// Klien OrderService yang terhubung ke API Laravel sungguhan.
///
/// [baseUrl] default menunjuk ke 127.0.0.1 untuk pengujian di Flutter
/// web/desktop. Override lewat constructor saat menjalankan di Android
/// emulator (10.0.2.2), device fisik, iOS simulator, atau saat pengujian.
class OrderService {
  OrderService({String baseUrl = 'http://127.0.0.1:8000/api'}) : _baseUrl = baseUrl;

  final String _baseUrl;
  static const String _tokenKey = 'auth_token';
  static const Duration _timeout = Duration(seconds: 15);

  /// userId tidak dikirim: server mengambil pemilik order dari token Bearer.
  Future<Order> createOrder({
    required PickupType pickupType,
    required List<OrderItemInput> items,
    String? catatan,
  }) async {
    if (items.isEmpty) {
      throw Exception('Order harus memiliki minimal satu layanan');
    }

    final body = {
      'items': items
          .map((item) => {
                'service_id': item.serviceId,
                'berat': item.berat,
              })
          .toList(),
      'pickup_type': pickupType.toJson(),
      if (catatan != null && catatan.isNotEmpty) 'catatan': catatan,
    };

    final response = await _authorizedRequest('POST', '/orders', body: body);
    final decoded = _decodeRaw(response);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Order.fromJson(_extractObject(decoded));
    }

    throw _errorFor(response.statusCode, decoded is Map<String, dynamic> ? decoded : {});
  }

  Future<List<Order>> getOrders() async {
    final response = await _authorizedRequest('GET', '/orders');
    final decoded = _decodeRaw(response);

    if (response.statusCode == 200) {
      return _extractList(decoded)
          .whereType<Map<String, dynamic>>()
          .map(Order.fromJson)
          .toList();
    }

    throw _errorFor(response.statusCode, decoded is Map<String, dynamic> ? decoded : {});
  }

  Future<OrderDetail> getOrderDetail(int orderId) async {
    final response = await _authorizedRequest('GET', '/orders/$orderId');
    final decoded = _decodeRaw(response);

    if (response.statusCode == 200) {
      final json = _extractObject(decoded);
      final order = Order.fromJson(json);

      final itemsJson = json['order_items'];
      final items = itemsJson is List
          ? itemsJson.whereType<Map<String, dynamic>>().map(OrderItem.fromJson).toList()
          : <OrderItem>[];

      final logsJson = json['status_logs'];
      final logs = logsJson is List
          ? (logsJson.whereType<Map<String, dynamic>>().map(LaundryStatusLog.fromJson).toList()
            ..sort((a, b) => a.createdAt.compareTo(b.createdAt)))
          : <LaundryStatusLog>[];

      return OrderDetail(order: order, items: items, statusLogs: logs);
    }

    if (response.statusCode == 404) {
      throw Exception('Order dengan id $orderId tidak ditemukan');
    }

    throw _errorFor(response.statusCode, decoded is Map<String, dynamic> ? decoded : {});
  }

  Future<Order> updateOrderStatus({
    required int orderId,
    required OrderStatus status,
    String? keterangan,
  }) async {
    final body = {
      'status': status.toJson(),
      if (keterangan != null && keterangan.isNotEmpty) 'keterangan': keterangan,
    };

    final response = await _authorizedRequest('PATCH', '/orders/$orderId/status', body: body);
    final decoded = _decodeRaw(response);

    if (response.statusCode == 200) {
      return Order.fromJson(_extractObject(decoded));
    }

    if (response.statusCode == 404) {
      throw Exception('Order dengan id $orderId tidak ditemukan');
    }

    throw _errorFor(response.statusCode, decoded is Map<String, dynamic> ? decoded : {});
  }

  Future<http.Response> _authorizedRequest(
    String method,
    String path, {
    Map<String, dynamic>? body,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);

    if (token == null) {
      throw Exception('Anda belum login, silakan login terlebih dahulu');
    }

    final uri = Uri.parse('$_baseUrl$path');
    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      if (method == 'POST' || method == 'PATCH') 'Content-Type': 'application/json',
    };

    try {
      if (method == 'POST') {
        return await http
            .post(uri, headers: headers, body: jsonEncode(body ?? {}))
            .timeout(_timeout);
      }
      if (method == 'PATCH') {
        return await http
            .patch(uri, headers: headers, body: jsonEncode(body ?? {}))
            .timeout(_timeout);
      }
      return await http.get(uri, headers: headers).timeout(_timeout);
    } on TimeoutException {
      throw Exception('Waktu koneksi ke server habis, silakan coba lagi');
    } on http.ClientException {
      throw Exception('Tidak dapat terhubung ke server. Periksa koneksi internet Anda.');
    }
  }

  dynamic _decodeRaw(http.Response response) {
    if (response.body.isEmpty) return null;
    try {
      return jsonDecode(response.body);
    } catch (_) {
      return null;
    }
  }

  /// Objek tunggal (mis. hasil create/detail order) bisa dikirim polos atau
  /// dibungkus dalam `{ "data": {...} }` (pola umum Laravel API Resource).
  Map<String, dynamic> _extractObject(dynamic decoded) {
    if (decoded is Map<String, dynamic>) {
      final data = decoded['data'];
      if (data is Map<String, dynamic>) return data;
      return decoded;
    }
    return {};
  }

  /// Daftar order bisa dikirim sebagai array JSON polos, atau dibungkus
  /// dalam `{ "data": [...] }`.
  List<dynamic> _extractList(dynamic decoded) {
    if (decoded is List) return decoded;
    if (decoded is Map<String, dynamic> && decoded['data'] is List) {
      return decoded['data'] as List;
    }
    return const [];
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
      case 404:
        return 'Data tidak ditemukan';
      case 422:
        return 'Data yang dikirim tidak valid';
      case 500:
        return 'Terjadi kesalahan pada server, silakan coba lagi nanti';
      default:
        return 'Terjadi kesalahan (kode $statusCode)';
    }
  }
}
