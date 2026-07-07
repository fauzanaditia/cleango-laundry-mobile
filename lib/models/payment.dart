enum PaymentMethod {
  tunai,
  transferBank,
  qris,
  eWallet,
}

enum PaymentStatus {
  belumLunas,
  lunas,
}

extension PaymentMethodX on PaymentMethod {
  String toJson() => name;

  static PaymentMethod fromJson(String value) {
    return PaymentMethod.values.firstWhere(
      (e) => e.name == value,
      orElse: () => throw ArgumentError('Unknown PaymentMethod: $value'),
    );
  }
}

extension PaymentStatusX on PaymentStatus {
  String toJson() => name;

  static PaymentStatus fromJson(String value) {
    return PaymentStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => throw ArgumentError('Unknown PaymentStatus: $value'),
    );
  }
}

class Payment {
  final int id;
  final int orderId;
  final PaymentMethod metode;
  final double jumlahBayar;
  final PaymentStatus status;
  final DateTime? tanggalBayar;
  final String? buktiBayar;
  final String? catatan;
  final DateTime createdAt;
  final DateTime updatedAt;

  Payment({
    required this.id,
    required this.orderId,
    required this.metode,
    required this.jumlahBayar,
    required this.status,
    this.tanggalBayar,
    this.buktiBayar,
    this.catatan,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'] as int,
      orderId: json['orderId'] as int,
      metode: PaymentMethodX.fromJson(json['metode'] as String),
      jumlahBayar: (json['jumlahBayar'] as num).toDouble(),
      status: PaymentStatusX.fromJson(json['status'] as String),
      tanggalBayar: json['tanggalBayar'] != null
          ? DateTime.parse(json['tanggalBayar'] as String)
          : null,
      buktiBayar: json['buktiBayar'] as String?,
      catatan: json['catatan'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'metode': metode.toJson(),
      'jumlahBayar': jumlahBayar,
      'status': status.toJson(),
      'tanggalBayar': tanggalBayar?.toIso8601String(),
      'buktiBayar': buktiBayar,
      'catatan': catatan,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
