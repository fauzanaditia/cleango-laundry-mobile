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
      id: json['id'] as int,
      orderId: json['orderId'] as int,
      status: OrderStatusX.fromJson(json['status'] as String),
      keterangan: json['keterangan'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'status': status.toJson(),
      'keterangan': keterangan,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
