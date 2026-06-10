import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yuva_raithu_app/features/orders/domain/order.dart';
import 'package:yuva_raithu_app/features/orders/presentation/checkout_screen.dart';

final myOrdersProvider = FutureProvider<List<Order>>((ref) {
  final repository = ref.watch(orderRepositoryProvider);
  return repository.getMyOrders();
});

class OrderHistoryScreen extends ConsumerWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(myOrdersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: ordersAsync.when(
        data: (orders) {
          if (orders.isEmpty) {
            return const Center(child: Text('You have no orders yet.'));
          }
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text('Order #${order.id} - ${order.status}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Total: ₹${order.totalAmount.toStringAsFixed(2)}\nOrdered on: ${order.createdAt}'),
                  isThreeLine: true,
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // View order details
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
