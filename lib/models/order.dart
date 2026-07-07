enum OrderStatus {
  baru,
  diterima,
  dicuci,
  dikeringkan,
  disetrika,
  qualityCheck,
  selesai,
  dibatalkan,
}

enum PickupType {
  ambilDiStore,
  antarKeAlamat,
}

extension OrderStatusX on OrderStatus {
  String toJson() => name;

  static OrderStatus fromJson(String value) {
    return OrderStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => throw ArgumentError('Unknown OrderStatus: $value'),
    );
  }
}

extension PickupTypeX on PickupType {
  String toJson() => name;

  static PickupType fromJson(String value) {
    return PickupType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => throw ArgumentError('Unknown PickupType: $value'),
    );
  }
}

class Order {
  final int id;
  final String kodeOrder;
  final int userId;
  final DateTime tanggalOrder;
  final OrderStatus status;
  final PickupType pickupType;
  final DateTime? estimasiSelesai;
  final double totalHarga;
  final String? catatan;
  final DateTime createdAt;
  final DateTime updatedAt;

  Order({
    required this.id,
    required this.kodeOrder,
    required this.userId,
    required this.tanggalOrder,
    required this.status,
    required this.pickupType,
    this.estimasiSelesai,
    required this.totalHarga,
    this.catatan,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as int,
      kodeOrder: json['kodeOrder'] as String,
      userId: json['userId'] as int,
      tanggalOrder: DateTime.parse(json['tanggalOrder'] as String),
      status: OrderStatusX.fromJson(json['status'] as String),
      pickupType: PickupTypeX.fromJson(json['pickupType'] as String),
      estimasiSelesai: json['estimasiSelesai'] != null
          ? DateTime.parse(json['estimasiSelesai'] as String)
          : null,
      totalHarga: (json['totalHarga'] as num).toDouble(),
      catatan: json['catatan'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kodeOrder': kodeOrder,
      'userId': userId,
      'tanggalOrder': tanggalOrder.toIso8601String(),
      'status': status.toJson(),
      'pickupType': pickupType.toJson(),
      'estimasiSelesai': estimasiSelesai?.toIso8601String(),
      'totalHarga': totalHarga,
      'catatan': catatan,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
