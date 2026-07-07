import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class AuthResult {
  final User user;
  final String token;

  AuthResult({required this.user, required this.token});
}

/// Klien AuthService yang terhubung ke API Laravel sungguhan.
///
/// [baseUrl] default menunjuk ke 127.0.0.1 untuk pengujian di Flutter web/desktop,
/// bukan alamat loopback Android emulator (10.0.2.2). Override lewat constructor
/// saat menjalankan di Android emulator, device fisik, iOS simulator, atau saat pengujian.
class AuthService {
  AuthService({String baseUrl = 'http://127.0.0.1:8000/api'}) : _baseUrl = baseUrl;

  final String _baseUrl;
  static const String _tokenKey = 'auth_token';
  static const Duration _timeout = Duration(seconds: 15);

  static const Map<String, String> _jsonHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future<User> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? phone,
  }) async {
    final response = await _post('/auth/register', {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
      if (phone != null && phone.isNotEmpty) 'phone': phone,
    });

    final body = _decodeBody(response);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return _userFromApiJson(_extractUserJson(body));
    }

    throw _errorFor(response.statusCode, body);
  }

  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    final response = await _post('/auth/login', {
      'email': email,
      'password': password,
    });

    final body = _decodeBody(response);

    if (response.statusCode == 200) {
      final token = _extractToken(body);
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak ditemukan pada respons server');
      }

      final user = _userFromApiJson(_extractUserJson(body));

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);

      return AuthResult(user: user, token: token);
    }

    throw _errorFor(response.statusCode, body);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);

    if (token == null) {
      // Sudah tidak ada sesi tersimpan, anggap sudah logout.
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/logout'),
        headers: {
          ..._jsonHeaders,
          'Authorization': 'Bearer $token',
        },
      ).timeout(_timeout);

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw _errorFor(response.statusCode, _decodeBody(response));
      }
    } on TimeoutException {
      throw Exception('Waktu koneksi ke server habis, silakan coba lagi');
    } on http.ClientException {
      throw Exception('Tidak dapat terhubung ke server. Periksa koneksi internet Anda.');
    } finally {
      // Token lokal tetap dihapus meskipun permintaan logout ke server gagal,
      // supaya pengguna tidak terjebak dalam sesi yang sudah tidak valid.
      await prefs.remove(_tokenKey);
    }
  }

  Future<http.Response> _post(String path, Map<String, dynamic> body) async {
    try {
      return await http
          .post(
            Uri.parse('$_baseUrl$path'),
            headers: _jsonHeaders,
            body: jsonEncode(body),
          )
          .timeout(_timeout);
    } on TimeoutException {
      throw Exception('Waktu koneksi ke server habis, silakan coba lagi');
    } on http.ClientException {
      throw Exception('Tidak dapat terhubung ke server. Periksa koneksi internet Anda.');
    }
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

  Map<String, dynamic> _extractUserJson(Map<String, dynamic> body) {
    final data = body['data'];
    if (data is Map<String, dynamic>) {
      final nestedUser = data['user'];
      if (nestedUser is Map<String, dynamic>) return nestedUser;
      return data;
    }
    final user = body['user'];
    if (user is Map<String, dynamic>) return user;
    return body;
  }

  String? _extractToken(Map<String, dynamic> body) {
    final data = body['data'];
    if (data is Map<String, dynamic>) {
      final token = data['token'] ?? data['access_token'];
      if (token != null) return token.toString();
    }
    final token = body['token'] ?? body['access_token'];
    return token?.toString();
  }

  /// Membangun [User] dari respons API. Password tidak pernah dikirim balik
  /// oleh server (dan memang tidak seharusnya), sehingga diisi string kosong.
  User _userFromApiJson(Map<String, dynamic> json) {
    final now = DateTime.now();
    return User(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}') ?? 0,
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      password: '',
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
        return 'Email atau password salah';
      case 422:
        return 'Data yang dikirim tidak valid';
      case 500:
        return 'Terjadi kesalahan pada server, silakan coba lagi nanti';
      default:
        return 'Terjadi kesalahan (kode $statusCode)';
    }
  }
}
