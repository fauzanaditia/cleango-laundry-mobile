enum PaymentMethod {
  cash,
  qris,
}

enum PaymentStatus {
  pending,
  lunas,
  gagal,
}

extension PaymentMethodX on PaymentMethod {
  // Nilai enum backend persis case-sensitive: Cash, QRIS.
  String toJson() {
    switch (this) {
      case PaymentMethod.cash:
        return 'Cash';
      case PaymentMethod.qris:
        return 'QRIS';
    }
  }

  static PaymentMethod fromJson(String value) {
    switch (value) {
      case 'Cash':
        return PaymentMethod.cash;
      case 'QRIS':
        return PaymentMethod.qris;
      default:
        throw ArgumentError('Unknown PaymentMethod: $value');
    }
  }
}

extension PaymentStatusX on PaymentStatus {
  // Nilai enum backend persis case-sensitive: Pending, Lunas, Gagal.
  String toJson() {
    switch (this) {
      case PaymentStatus.pending:
        return 'Pending';
      case PaymentStatus.lunas:
        return 'Lunas';
      case PaymentStatus.gagal:
        return 'Gagal';
    }
  }

  static PaymentStatus fromJson(String value) {
    switch (value) {
      case 'Pending':
        return PaymentStatus.pending;
      case 'Lunas':
        return PaymentStatus.lunas;
      case 'Gagal':
        return PaymentStatus.gagal;
      default:
        throw ArgumentError('Unknown PaymentStatus: $value');
    }
  }
}

class Payment {
  final int id;
  final int orderId;
  final PaymentMethod metode;
  final double jumlah;
  final PaymentStatus status;
  final DateTime? tanggalBayar;
  final DateTime createdAt;
  final DateTime updatedAt;

  Payment({
    required this.id,
    required this.orderId,
    required this.metode,
    required this.jumlah,
    required this.status,
    this.tanggalBayar,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: _asInt(json['id']),
      orderId: _asInt(json['order_id']),
      metode: PaymentMethodX.fromJson(json['metode'] as String),
      // jumlah dikirim API sebagai string, mis. "42000.00".
      jumlah: _asDouble(json['jumlah']),
      status: PaymentStatusX.fromJson(json['status_pembayaran'] as String),
      tanggalBayar: json['tanggal_bayar'] != null
          ? DateTime.parse(json['tanggal_bayar'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'metode': metode.toJson(),
      'jumlah': jumlah,
      'status_pembayaran': status.toJson(),
      'tanggal_bayar': tanggalBayar?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
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
