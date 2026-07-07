import '../models/customer.dart';
import 'mock_data.dart';

class CustomerService {
  Future<List<Customer>> getCustomers({String? query}) async {
    await Future.delayed(const Duration(milliseconds: 600));

    if (query == null || query.trim().isEmpty) {
      return List.unmodifiable(MockData.customers);
    }

    final lowerQuery = query.trim().toLowerCase();
    return MockData.customers
        .where((c) =>
            c.name.toLowerCase().contains(lowerQuery) ||
            c.phone.toLowerCase().contains(lowerQuery))
        .toList();
  }

  Future<Customer> createCustomer({
    required String name,
    required String phone,
    String? email,
    String? address,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final now = DateTime.now();
    final customer = Customer(
      id: MockData.nextCustomerId++,
      name: name,
      phone: phone,
      email: email,
      address: address,
      createdAt: now,
      updatedAt: now,
    );

    MockData.customers.add(customer);
    return customer;
  }
}
