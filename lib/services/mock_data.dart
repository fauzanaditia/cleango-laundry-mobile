import '../models/customer.dart';
import '../models/laundry_status_log.dart';
import '../models/order.dart';
import '../models/order_item.dart';
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

  /// Nama tampilan untuk userId, dipakai layar admin (Data Order/Pembayaran)
  /// untuk menampilkan nama pelanggan tanpa perlu tabel User penuh per akun.
  static const Map<int, String> userNames = {
    1: 'Ahmad Fauzan',
    2: 'Andi',
    3: 'Budi',
    4: 'Citra',
    5: 'Dewi',
  };

  static final List<Customer> customers = [
    Customer(
      id: 1,
      name: 'Andi',
      phone: '0812-3456-7890',
      email: 'andi@email.com',
      address: 'Jl. Melati No. 10',
      createdAt: DateTime(2026, 2, 1),
      updatedAt: DateTime(2026, 2, 1),
    ),
    Customer(
      id: 2,
      name: 'Budi',
      phone: '0813-2222-1111',
      email: 'budi@email.com',
      address: 'Jl. Mawar No. 5',
      createdAt: DateTime(2026, 2, 3),
      updatedAt: DateTime(2026, 2, 3),
    ),
    Customer(
      id: 3,
      name: 'Citra',
      phone: '0812-9876-5432',
      email: 'citra@email.com',
      address: 'Jl. Anggrek No. 3',
      createdAt: DateTime(2026, 2, 5),
      updatedAt: DateTime(2026, 2, 5),
    ),
    Customer(
      id: 4,
      name: 'Dewi',
      phone: '0812-5555-6666',
      email: 'dewi@email.com',
      address: 'Jl. Dahlia No. 8',
      createdAt: DateTime(2026, 2, 7),
      updatedAt: DateTime(2026, 2, 7),
    ),
  ];

  static final List<Service> services = [
    Service(
      id: 1,
      name: 'Reguler',
      price: 7000,
      duration: 72,
      description: 'Selesai dalam 3 hari',
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    ),
    Service(
      id: 2,
      name: 'Express',
      price: 12000,
      duration: 24,
      description: 'Selesai dalam 1 hari',
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    ),
    Service(
      id: 3,
      name: 'Kilat',
      price: 18000,
      duration: 6,
      description: 'Selesai dalam 6 jam',
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    ),
  ];

  static final List<Order> orders = [
    Order(
      id: 1,
      kodeOrder: 'ORD20260620001',
      userId: 1,
      tanggalOrder: DateTime(2026, 6, 20),
      status: OrderStatus.selesai,
      pickupType: PickupType.antarKeAlamat,
      estimasiSelesai: DateTime(2026, 6, 23),
      totalHarga: 42000,
      catatan: null,
      createdAt: DateTime(2026, 6, 20),
      updatedAt: DateTime(2026, 6, 23),
    ),
    Order(
      id: 2,
      kodeOrder: 'ORD20260702002',
      userId: 1,
      tanggalOrder: DateTime(2026, 7, 2),
      status: OrderStatus.dicuci,
      pickupType: PickupType.ambilDiStore,
      estimasiSelesai: DateTime(2026, 7, 5),
      totalHarga: 60000,
      catatan: null,
      createdAt: DateTime(2026, 7, 2),
      updatedAt: DateTime(2026, 7, 3),
    ),
    Order(
      id: 3,
      kodeOrder: 'ORD20260703003',
      userId: 1,
      tanggalOrder: DateTime(2026, 7, 3),
      status: OrderStatus.disetrika,
      pickupType: PickupType.antarKeAlamat,
      estimasiSelesai: DateTime(2026, 7, 6),
      totalHarga: 54000,
      catatan: null,
      createdAt: DateTime(2026, 7, 3),
      updatedAt: DateTime(2026, 7, 4),
    ),
    Order(
      id: 4,
      kodeOrder: 'ORD20260630004',
      userId: 1,
      tanggalOrder: DateTime(2026, 6, 30),
      status: OrderStatus.dibatalkan,
      pickupType: PickupType.ambilDiStore,
      estimasiSelesai: null,
      totalHarga: 35000,
      catatan: 'Dibatalkan oleh pelanggan',
      createdAt: DateTime(2026, 6, 30),
      updatedAt: DateTime(2026, 6, 30),
    ),
    Order(
      id: 5,
      kodeOrder: 'ORD20260705005',
      userId: 1,
      tanggalOrder: DateTime(2026, 7, 5),
      status: OrderStatus.diterima,
      pickupType: PickupType.antarKeAlamat,
      estimasiSelesai: DateTime(2026, 7, 8),
      totalHarga: 84000,
      catatan: null,
      createdAt: DateTime(2026, 7, 5),
      updatedAt: DateTime(2026, 7, 5),
    ),

    // Order milik pelanggan lain (Andi/Budi/Citra/Dewi) untuk demo layar admin.
    Order(
      id: 6,
      kodeOrder: 'ORD20260701006',
      userId: 2,
      tanggalOrder: DateTime(2026, 7, 1),
      status: OrderStatus.baru,
      pickupType: PickupType.ambilDiStore,
      estimasiSelesai: null,
      totalHarga: 42000,
      catatan: null,
      createdAt: DateTime(2026, 7, 1),
      updatedAt: DateTime(2026, 7, 1),
    ),
    Order(
      id: 7,
      kodeOrder: 'ORD20260630007',
      userId: 3,
      tanggalOrder: DateTime(2026, 6, 30),
      status: OrderStatus.diterima,
      pickupType: PickupType.antarKeAlamat,
      estimasiSelesai: DateTime(2026, 7, 1),
      totalHarga: 36000,
      catatan: null,
      createdAt: DateTime(2026, 6, 30),
      updatedAt: DateTime(2026, 6, 30),
    ),
    Order(
      id: 8,
      kodeOrder: 'ORD20260629008',
      userId: 4,
      tanggalOrder: DateTime(2026, 6, 29),
      status: OrderStatus.dicuci,
      pickupType: PickupType.ambilDiStore,
      estimasiSelesai: DateTime(2026, 6, 29, 6),
      totalHarga: 54000,
      catatan: null,
      createdAt: DateTime(2026, 6, 29),
      updatedAt: DateTime(2026, 6, 29),
    ),
    Order(
      id: 9,
      kodeOrder: 'ORD20260615009',
      userId: 5,
      tanggalOrder: DateTime(2026, 6, 15),
      status: OrderStatus.selesai,
      pickupType: PickupType.ambilDiStore,
      estimasiSelesai: DateTime(2026, 6, 18),
      totalHarga: 28000,
      catatan: null,
      createdAt: DateTime(2026, 6, 15),
      updatedAt: DateTime(2026, 6, 18),
    ),
  ];

  static final List<OrderItem> orderItems = [
    OrderItem(
      id: 1,
      orderId: 1,
      serviceId: 1,
      berat: 6.0,
      qty: 1,
      harga: 7000,
      subtotal: 42000,
      createdAt: DateTime(2026, 6, 20),
      updatedAt: DateTime(2026, 6, 20),
    ),
    OrderItem(
      id: 2,
      orderId: 2,
      serviceId: 2,
      berat: 5.0,
      qty: 1,
      harga: 12000,
      subtotal: 60000,
      createdAt: DateTime(2026, 7, 2),
      updatedAt: DateTime(2026, 7, 2),
    ),
    OrderItem(
      id: 3,
      orderId: 3,
      serviceId: 3,
      berat: 3.0,
      qty: 1,
      harga: 18000,
      subtotal: 54000,
      createdAt: DateTime(2026, 7, 3),
      updatedAt: DateTime(2026, 7, 3),
    ),
    OrderItem(
      id: 4,
      orderId: 4,
      serviceId: 1,
      berat: 5.0,
      qty: 1,
      harga: 7000,
      subtotal: 35000,
      createdAt: DateTime(2026, 6, 30),
      updatedAt: DateTime(2026, 6, 30),
    ),
    OrderItem(
      id: 5,
      orderId: 5,
      serviceId: 1,
      berat: 12.0,
      qty: 1,
      harga: 7000,
      subtotal: 84000,
      createdAt: DateTime(2026, 7, 5),
      updatedAt: DateTime(2026, 7, 5),
    ),
    OrderItem(
      id: 6,
      orderId: 6,
      serviceId: 1,
      berat: 6.0,
      qty: 1,
      harga: 7000,
      subtotal: 42000,
      createdAt: DateTime(2026, 7, 1),
      updatedAt: DateTime(2026, 7, 1),
    ),
    OrderItem(
      id: 7,
      orderId: 7,
      serviceId: 2,
      berat: 3.0,
      qty: 1,
      harga: 12000,
      subtotal: 36000,
      createdAt: DateTime(2026, 6, 30),
      updatedAt: DateTime(2026, 6, 30),
    ),
    OrderItem(
      id: 8,
      orderId: 8,
      serviceId: 3,
      berat: 3.0,
      qty: 1,
      harga: 18000,
      subtotal: 54000,
      createdAt: DateTime(2026, 6, 29),
      updatedAt: DateTime(2026, 6, 29),
    ),
    OrderItem(
      id: 9,
      orderId: 9,
      serviceId: 1,
      berat: 4.0,
      qty: 1,
      harga: 7000,
      subtotal: 28000,
      createdAt: DateTime(2026, 6, 15),
      updatedAt: DateTime(2026, 6, 15),
    ),
  ];

  static final List<LaundryStatusLog> statusLogs = [
    // Order 1 - selesai (siklus lengkap)
    LaundryStatusLog(id: 1, orderId: 1, status: OrderStatus.diterima, keterangan: 'Pesanan diterima di outlet', createdAt: DateTime(2026, 6, 20, 9, 0)),
    LaundryStatusLog(id: 2, orderId: 1, status: OrderStatus.dicuci, keterangan: 'Pakaian sedang dicuci', createdAt: DateTime(2026, 6, 20, 13, 0)),
    LaundryStatusLog(id: 3, orderId: 1, status: OrderStatus.dikeringkan, keterangan: 'Pakaian sedang dikeringkan', createdAt: DateTime(2026, 6, 21, 9, 0)),
    LaundryStatusLog(id: 4, orderId: 1, status: OrderStatus.disetrika, keterangan: 'Pakaian sedang disetrika', createdAt: DateTime(2026, 6, 22, 9, 0)),
    LaundryStatusLog(id: 5, orderId: 1, status: OrderStatus.qualityCheck, keterangan: 'Pemeriksaan kualitas akhir', createdAt: DateTime(2026, 6, 22, 15, 0)),
    LaundryStatusLog(id: 6, orderId: 1, status: OrderStatus.selesai, keterangan: 'Pesanan selesai dan siap diambil/diantar', createdAt: DateTime(2026, 6, 23, 10, 0)),

    // Order 2 - proses (dicuci)
    LaundryStatusLog(id: 7, orderId: 2, status: OrderStatus.diterima, keterangan: 'Pesanan diterima di outlet', createdAt: DateTime(2026, 7, 2, 10, 0)),
    LaundryStatusLog(id: 8, orderId: 2, status: OrderStatus.dicuci, keterangan: 'Pakaian sedang dicuci', createdAt: DateTime(2026, 7, 3, 8, 0)),

    // Order 3 - proses (disetrika)
    LaundryStatusLog(id: 9, orderId: 3, status: OrderStatus.diterima, keterangan: 'Pesanan diterima di outlet', createdAt: DateTime(2026, 7, 3, 11, 0)),
    LaundryStatusLog(id: 10, orderId: 3, status: OrderStatus.dicuci, keterangan: 'Pakaian sedang dicuci', createdAt: DateTime(2026, 7, 3, 15, 0)),
    LaundryStatusLog(id: 11, orderId: 3, status: OrderStatus.dikeringkan, keterangan: 'Pakaian sedang dikeringkan', createdAt: DateTime(2026, 7, 4, 8, 0)),
    LaundryStatusLog(id: 12, orderId: 3, status: OrderStatus.disetrika, keterangan: 'Pakaian sedang disetrika', createdAt: DateTime(2026, 7, 4, 13, 0)),

    // Order 4 - dibatalkan
    LaundryStatusLog(id: 13, orderId: 4, status: OrderStatus.diterima, keterangan: 'Pesanan diterima di outlet', createdAt: DateTime(2026, 6, 30, 9, 0)),
    LaundryStatusLog(id: 14, orderId: 4, status: OrderStatus.dibatalkan, keterangan: 'Dibatalkan atas permintaan pelanggan', createdAt: DateTime(2026, 6, 30, 12, 0)),

    // Order 5 - baru diterima
    LaundryStatusLog(id: 15, orderId: 5, status: OrderStatus.diterima, keterangan: 'Pesanan diterima di outlet', createdAt: DateTime(2026, 7, 5, 9, 0)),

    // Order 6 - baru dibuat (Andi)
    LaundryStatusLog(id: 16, orderId: 6, status: OrderStatus.baru, keterangan: 'Pesanan berhasil dibuat, menunggu diterima outlet', createdAt: DateTime(2026, 7, 1, 8, 0)),

    // Order 7 - diterima (Budi)
    LaundryStatusLog(id: 17, orderId: 7, status: OrderStatus.diterima, keterangan: 'Pesanan diterima di outlet', createdAt: DateTime(2026, 6, 30, 9, 0)),

    // Order 8 - dicuci (Citra)
    LaundryStatusLog(id: 18, orderId: 8, status: OrderStatus.diterima, keterangan: 'Pesanan diterima di outlet', createdAt: DateTime(2026, 6, 29, 7, 0)),
    LaundryStatusLog(id: 19, orderId: 8, status: OrderStatus.dicuci, keterangan: 'Pakaian sedang dicuci', createdAt: DateTime(2026, 6, 29, 9, 0)),

    // Order 9 - selesai (Dewi, siklus lengkap)
    LaundryStatusLog(id: 20, orderId: 9, status: OrderStatus.diterima, keterangan: 'Pesanan diterima di outlet', createdAt: DateTime(2026, 6, 15, 9, 0)),
    LaundryStatusLog(id: 21, orderId: 9, status: OrderStatus.dicuci, keterangan: 'Pakaian sedang dicuci', createdAt: DateTime(2026, 6, 15, 13, 0)),
    LaundryStatusLog(id: 22, orderId: 9, status: OrderStatus.dikeringkan, keterangan: 'Pakaian sedang dikeringkan', createdAt: DateTime(2026, 6, 16, 9, 0)),
    LaundryStatusLog(id: 23, orderId: 9, status: OrderStatus.disetrika, keterangan: 'Pakaian sedang disetrika', createdAt: DateTime(2026, 6, 17, 9, 0)),
    LaundryStatusLog(id: 24, orderId: 9, status: OrderStatus.qualityCheck, keterangan: 'Pemeriksaan kualitas akhir', createdAt: DateTime(2026, 6, 17, 15, 0)),
    LaundryStatusLog(id: 25, orderId: 9, status: OrderStatus.selesai, keterangan: 'Pesanan selesai dan siap diambil/diantar', createdAt: DateTime(2026, 6, 18, 10, 0)),
  ];

  static final List<Payment> payments = [
    Payment(
      id: 1,
      orderId: 1,
      metode: PaymentMethod.tunai,
      jumlahBayar: 42000,
      status: PaymentStatus.lunas,
      tanggalBayar: DateTime(2026, 6, 23, 10, 30),
      buktiBayar: null,
      catatan: null,
      createdAt: DateTime(2026, 6, 23, 10, 30),
      updatedAt: DateTime(2026, 6, 23, 10, 30),
    ),
    Payment(
      id: 2,
      orderId: 2,
      metode: PaymentMethod.transferBank,
      jumlahBayar: 60000,
      status: PaymentStatus.belumLunas,
      tanggalBayar: null,
      buktiBayar: null,
      catatan: null,
      createdAt: DateTime(2026, 7, 2, 10, 5),
      updatedAt: DateTime(2026, 7, 2, 10, 5),
    ),
    Payment(
      id: 3,
      orderId: 3,
      metode: PaymentMethod.qris,
      jumlahBayar: 54000,
      status: PaymentStatus.belumLunas,
      tanggalBayar: null,
      buktiBayar: null,
      catatan: null,
      createdAt: DateTime(2026, 7, 3, 11, 5),
      updatedAt: DateTime(2026, 7, 3, 11, 5),
    ),
    Payment(
      id: 4,
      orderId: 5,
      metode: PaymentMethod.eWallet,
      jumlahBayar: 84000,
      status: PaymentStatus.belumLunas,
      tanggalBayar: null,
      buktiBayar: null,
      catatan: null,
      createdAt: DateTime(2026, 7, 5, 9, 5),
      updatedAt: DateTime(2026, 7, 5, 9, 5),
    ),
    Payment(
      id: 5,
      orderId: 6,
      metode: PaymentMethod.tunai,
      jumlahBayar: 42000,
      status: PaymentStatus.belumLunas,
      tanggalBayar: null,
      buktiBayar: null,
      catatan: null,
      createdAt: DateTime(2026, 7, 1, 8, 5),
      updatedAt: DateTime(2026, 7, 1, 8, 5),
    ),
    Payment(
      id: 6,
      orderId: 7,
      metode: PaymentMethod.qris,
      jumlahBayar: 36000,
      status: PaymentStatus.lunas,
      tanggalBayar: DateTime(2026, 6, 30, 9, 30),
      buktiBayar: null,
      catatan: null,
      createdAt: DateTime(2026, 6, 30, 9, 30),
      updatedAt: DateTime(2026, 6, 30, 9, 30),
    ),
    Payment(
      id: 7,
      orderId: 8,
      metode: PaymentMethod.transferBank,
      jumlahBayar: 54000,
      status: PaymentStatus.lunas,
      tanggalBayar: DateTime(2026, 6, 29, 7, 30),
      buktiBayar: null,
      catatan: null,
      createdAt: DateTime(2026, 6, 29, 7, 30),
      updatedAt: DateTime(2026, 6, 29, 7, 30),
    ),
    Payment(
      id: 8,
      orderId: 9,
      metode: PaymentMethod.tunai,
      jumlahBayar: 28000,
      status: PaymentStatus.lunas,
      tanggalBayar: DateTime(2026, 6, 18, 10, 30),
      buktiBayar: null,
      catatan: null,
      createdAt: DateTime(2026, 6, 18, 10, 30),
      updatedAt: DateTime(2026, 6, 18, 10, 30),
    ),
  ];

  static int nextUserId = users.length + 1;
  static int nextCustomerId = customers.length + 1;
  static int nextServiceId = services.length + 1;
  static int nextOrderId = orders.length + 1;
  static int nextOrderItemId = orderItems.length + 1;
  static int nextStatusLogId = statusLogs.length + 1;
  static int nextPaymentId = payments.length + 1;
}
