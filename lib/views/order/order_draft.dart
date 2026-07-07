import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/order.dart';
import '../../models/payment.dart';
import '../../models/service.dart';

/// Biaya tetap layanan antar-jemput saat pickupType == antarKeAlamat.
const double kBiayaAntarJemput = 5000;

/// State kumpulan pilihan pengguna yang dibawa berjalan melalui alur
/// Buat Order -> Pilih Paket -> Detail Order -> Pembayaran.
class OrderDraft {
  OrderDraft({
    this.layanan = 'Cuci + Setrika',
    DateTime? tanggalOrder,
    this.jenisCucian = 'Pakaian',
    this.catatan,
    this.pickupType = PickupType.ambilDiStore,
    this.service,
    this.berat = 5,
  }) : tanggalOrder = tanggalOrder ?? DateTime.now();

  String layanan;
  DateTime tanggalOrder;
  String jenisCucian;
  String? catatan;
  PickupType pickupType;
  Service? service;
  double berat;

  double get hargaPerKg => service?.price ?? 0;
  double get subtotal => berat * hargaPerKg;
  double get biayaAntarJemput =>
      pickupType == PickupType.antarKeAlamat ? kBiayaAntarJemput : 0;
  double get totalBayar => subtotal + biayaAntarJemput;

  DateTime get estimasiSelesai =>
      tanggalOrder.add(Duration(hours: service?.duration ?? 0));
}

String formatDurationLabel(int hours) {
  if (hours % 24 == 0) {
    final days = hours ~/ 24;
    return '$days Hari';
  }
  return '$hours Jam';
}

const _bulanIndo = [
  'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
  'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
];

String formatTanggalIndo(DateTime date) {
  return '${date.day} ${_bulanIndo[date.month - 1]} ${date.year}';
}

String formatTanggalWaktuIndo(DateTime date) {
  final hh = date.hour.toString().padLeft(2, '0');
  final mm = date.minute.toString().padLeft(2, '0');
  return '${formatTanggalIndo(date)} - $hh:$mm';
}

final _rupiahFormat = NumberFormat.currency(
  locale: 'id_ID',
  symbol: 'Rp ',
  decimalDigits: 0,
);

String formatRupiah(num value) => _rupiahFormat.format(value);

/// Enam tahapan proses laundry yang ditampilkan pada timeline Status Order.
const orderProcessStages = [
  OrderStatus.diterima,
  OrderStatus.dicuci,
  OrderStatus.dikeringkan,
  OrderStatus.disetrika,
  OrderStatus.qualityCheck,
  OrderStatus.selesai,
];

const _statusLabels = {
  OrderStatus.baru: 'Baru',
  OrderStatus.diterima: 'Diterima',
  OrderStatus.dicuci: 'Dicuci',
  OrderStatus.dikeringkan: 'Dikeringkan',
  OrderStatus.disetrika: 'Disetrika',
  OrderStatus.qualityCheck: 'Quality Check',
  OrderStatus.selesai: 'Selesai',
  OrderStatus.dibatalkan: 'Dibatalkan',
};

String orderStatusLabel(OrderStatus status) => _statusLabels[status] ?? status.name;

/// Label ringkas untuk badge di list Riwayat Order: Selesai / Dibatalkan / Proses.
String orderStatusBucketLabel(OrderStatus status) {
  switch (status) {
    case OrderStatus.selesai:
      return 'Selesai';
    case OrderStatus.dibatalkan:
      return 'Dibatalkan';
    default:
      return 'Proses';
  }
}

Color orderStatusBucketColor(OrderStatus status) {
  switch (status) {
    case OrderStatus.selesai:
      return const Color(0xFF34C759);
    case OrderStatus.dibatalkan:
      return const Color(0xFFE74C3C);
    default:
      return const Color(0xFFF5A623);
  }
}

bool isOrderInProses(OrderStatus status) =>
    status != OrderStatus.selesai && status != OrderStatus.dibatalkan;

String paymentStatusLabel(PaymentStatus status) =>
    status == PaymentStatus.lunas ? 'LUNAS' : 'BELUM LUNAS';

Color paymentStatusColor(PaymentStatus status) =>
    status == PaymentStatus.lunas ? const Color(0xFF34C759) : const Color(0xFFF5A623);
