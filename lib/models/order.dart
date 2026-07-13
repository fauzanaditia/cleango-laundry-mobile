enum OrderStatus {
  menunggu,
  diproses,
  dicuci,
  dikeringkan,
  disetrika,
  selesai,
  diambil,
}

enum PickupType {
  ambilDiStore,
  antarKeAlamat,
}

extension OrderStatusX on OrderStatus {
  // Nilai enum backend persis case-sensitive: Menunggu, Diproses, Dicuci,
  // Dikeringkan, Disetrika, Selesai, Diambil.
  String toJson() {
    switch (this) {
      case OrderStatus.menunggu:
        return 'Menunggu';
      case OrderStatus.diproses:
        return 'Diproses';
      case OrderStatus.dicuci:
        return 'Dicuci';
      case OrderStatus.dikeringkan:
        return 'Dikeringkan';
      case OrderStatus.disetrika:
        return 'Disetrika';
      case OrderStatus.selesai:
        return 'Selesai';
      case OrderStatus.diambil:
        return 'Diambil';
    }
  }

  static OrderStatus fromJson(String value) {
    switch (value) {
      case 'Menunggu':
        return OrderStatus.menunggu;
      case 'Diproses':
        return OrderStatus.diproses;
      case 'Dicuci':
        return OrderStatus.dicuci;
      case 'Dikeringkan':
        return OrderStatus.dikeringkan;
      case 'Disetrika':
        return OrderStatus.disetrika;
      case 'Selesai':
        return OrderStatus.selesai;
      case 'Diambil':
        return OrderStatus.diambil;
      default:
        throw ArgumentError('Unknown OrderStatus: $value');
    }
  }
}

extension PickupTypeX on PickupType {
  // Nilai enum backend: 'Jemput' (ambil di store/jemput sendiri) dan
  // 'Antar' (diantar ke alamat). Tidak terkait dengan label UI.
  String toJson() {
    switch (this) {
      case PickupType.ambilDiStore:
        return 'Jemput';
      case PickupType.antarKeAlamat:
        return 'Antar';
    }
  }

  static PickupType fromJson(String value) {
    switch (value) {
      case 'Jemput':
        return PickupType.ambilDiStore;
      case 'Antar':
        return PickupType.antarKeAlamat;
      default:
        throw ArgumentError('Unknown PickupType: $value');
    }
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
      id: _asInt(json['id']),
      kodeOrder: json['kode_order'] as String,
      userId: _asInt(json['user_id']),
      tanggalOrder: DateTime.parse(json['tanggal_order'] as String),
      status: OrderStatusX.fromJson(json['status'] as String),
      pickupType: PickupTypeX.fromJson(json['pickup_type'] as String),
      estimasiSelesai: json['estimasi_selesai'] != null
          ? DateTime.parse(json['estimasi_selesai'] as String)
          : null,
      // total_harga dikirim API sebagai string, mis. "42000.00".
      totalHarga: _asDouble(json['total_harga']),
      catatan: json['catatan'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kode_order': kodeOrder,
      'user_id': userId,
      'tanggal_order': tanggalOrder.toIso8601String(),
      'status': status.toJson(),
      'pickup_type': pickupType.toJson(),
      'estimasi_selesai': estimasiSelesai?.toIso8601String(),
      'total_harga': totalHarga,
      'catatan': catatan,
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
