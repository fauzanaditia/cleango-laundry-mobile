import 'order.dart';

class LaundryStatusLog {
  final int id;
  final int orderId;
  final OrderStatus status;
  final String? keterangan;
  final DateTime createdAt;

  LaundryStatusLog({
    required this.id,
    required this.orderId,
    required this.status,
    this.keterangan,
    required this.createdAt,
  });

  factory LaundryStatusLog.fromJson(Map<String, dynamic> json) {
    return LaundryStatusLog(
      id: _asInt(json['id']),
      orderId: _asInt(json['order_id']),
      status: OrderStatusX.fromJson(json['status'] as String),
      keterangan: json['keterangan'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'status': status.toJson(),
      'keterangan': keterangan,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse('$value') ?? 0;
}
