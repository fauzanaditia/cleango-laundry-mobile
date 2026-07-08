class Service {
  final int id;
  final String namaLayanan;
  final double hargaPerKg;
  final int estimasiHari;
  final String? deskripsi;
  final DateTime createdAt;
  final DateTime updatedAt;

  Service({
    required this.id,
    required this.namaLayanan,
    required this.hargaPerKg,
    required this.estimasiHari,
    this.deskripsi,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] as int,
      namaLayanan: json['nama_layanan'] as String,
      // harga_per_kg dikirim API sebagai string, mis. "7000.00".
      hargaPerKg: double.parse(json['harga_per_kg'].toString()),
      estimasiHari: json['estimasi_hari'] as int,
      deskripsi: json['deskripsi'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_layanan': namaLayanan,
      'harga_per_kg': hargaPerKg,
      'estimasi_hari': estimasiHari,
      'deskripsi': deskripsi,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
