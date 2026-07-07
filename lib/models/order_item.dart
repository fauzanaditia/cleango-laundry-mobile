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
      id: json['id'] as int,
      orderId: json['orderId'] as int,
      serviceId: json['serviceId'] as int,
      berat: (json['berat'] as num).toDouble(),
      qty: json['qty'] as int,
      harga: (json['harga'] as num).toDouble(),
      subtotal: (json['subtotal'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'serviceId': serviceId,
      'berat': berat,
      'qty': qty,
      'harga': harga,
      'subtotal': subtotal,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
