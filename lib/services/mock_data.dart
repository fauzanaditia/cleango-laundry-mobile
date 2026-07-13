import '../models/payment.dart';
import '../models/service.dart';
import '../models/user.dart';

/// In-memory data store shared by all fake API services so that
/// order/payment/user data stays consistent across the simulated app flow.
class MockData {
  MockData._();

  static final List<User> users = [
    User(
      id: 1,
      name: 'Ahmad Fauzan',
      email: 'ahmad.fauzan@email.com',
      phone: '081234567890',
      password: 'password123',
      createdAt: DateTime(2026, 1, 10),
      updatedAt: DateTime(2026, 1, 10),
    ),
  ];

  static final List<Service> services = [
    Service(
      id: 1,
      namaLayanan: 'Reguler',
      hargaPerKg: 7000,
      estimasiHari: 72,
      deskripsi: 'Selesai dalam 3 hari',
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    ),
    Service(
      id: 2,
      namaLayanan: 'Express',
      hargaPerKg: 12000,
      estimasiHari: 24,
      deskripsi: 'Selesai dalam 1 hari',
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    ),
    Service(
      id: 3,
      namaLayanan: 'Kilat',
      hargaPerKg: 18000,
      estimasiHari: 6,
      deskripsi: 'Selesai dalam 6 jam',
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    ),
  ];

  static final List<Payment> payments = [
    Payment(
      id: 1,
      orderId: 1,
      metode: PaymentMethod.cash,
      jumlah: 42000,
      status: PaymentStatus.lunas,
      tanggalBayar: DateTime(2026, 6, 23, 10, 30),
      createdAt: DateTime(2026, 6, 23, 10, 30),
      updatedAt: DateTime(2026, 6, 23, 10, 30),
    ),
    Payment(
      id: 2,
      orderId: 2,
      metode: PaymentMethod.qris,
      jumlah: 60000,
      status: PaymentStatus.pending,
      tanggalBayar: null,
      createdAt: DateTime(2026, 7, 2, 10, 5),
      updatedAt: DateTime(2026, 7, 2, 10, 5),
    ),
    Payment(
      id: 3,
      orderId: 3,
      metode: PaymentMethod.qris,
      jumlah: 54000,
      status: PaymentStatus.pending,
      tanggalBayar: null,
      createdAt: DateTime(2026, 7, 3, 11, 5),
      updatedAt: DateTime(2026, 7, 3, 11, 5),
    ),
    Payment(
      id: 4,
      orderId: 5,
      metode: PaymentMethod.cash,
      jumlah: 84000,
      status: PaymentStatus.pending,
      tanggalBayar: null,
      createdAt: DateTime(2026, 7, 5, 9, 5),
      updatedAt: DateTime(2026, 7, 5, 9, 5),
    ),
    Payment(
      id: 5,
      orderId: 6,
      metode: PaymentMethod.cash,
      jumlah: 42000,
      status: PaymentStatus.pending,
      tanggalBayar: null,
      createdAt: DateTime(2026, 7, 1, 8, 5),
      updatedAt: DateTime(2026, 7, 1, 8, 5),
    ),
    Payment(
      id: 6,
      orderId: 7,
      metode: PaymentMethod.qris,
      jumlah: 36000,
      status: PaymentStatus.lunas,
      tanggalBayar: DateTime(2026, 6, 30, 9, 30),
      createdAt: DateTime(2026, 6, 30, 9, 30),
      updatedAt: DateTime(2026, 6, 30, 9, 30),
    ),
    Payment(
      id: 7,
      orderId: 8,
      metode: PaymentMethod.qris,
      jumlah: 54000,
      status: PaymentStatus.lunas,
      tanggalBayar: DateTime(2026, 6, 29, 7, 30),
      createdAt: DateTime(2026, 6, 29, 7, 30),
      updatedAt: DateTime(2026, 6, 29, 7, 30),
    ),
    Payment(
      id: 8,
      orderId: 9,
      metode: PaymentMethod.cash,
      jumlah: 28000,
      status: PaymentStatus.lunas,
      tanggalBayar: DateTime(2026, 6, 18, 10, 30),
      createdAt: DateTime(2026, 6, 18, 10, 30),
      updatedAt: DateTime(2026, 6, 18, 10, 30),
    ),
  ];

  static int nextUserId = users.length + 1;
  static int nextServiceId = services.length + 1;
  static int nextPaymentId = payments.length + 1;
}
