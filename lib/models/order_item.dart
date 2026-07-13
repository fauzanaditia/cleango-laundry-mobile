class OrderItem {
  final int id;
  final int orderId;
  final int serviceId;
  final double berat;
  final int qty;
  final double harga;
  final double subtotal;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.serviceId,
    required this.berat,
    required this.qty,
    required this.harga,
    required this.subtotal,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: _asInt(json['id']),
      orderId: _asInt(json['order_id']),
      serviceId: _asInt(json['service_id']),
      // berat/harga/subtotal dikirim API sebagai string, mis. "6.00".
      berat: _asDouble(json['berat']),
      qty: _asInt(json['qty']),
      harga: _asDouble(json['harga']),
      subtotal: _asDouble(json['subtotal']),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'service_id': serviceId,
      'berat': berat,
      'qty': qty,
      'harga': harga,
      'subtotal': subtotal,
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
