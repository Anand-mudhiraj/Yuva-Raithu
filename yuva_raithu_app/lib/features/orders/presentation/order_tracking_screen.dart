import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yuva_raithu_app/features/orders/domain/order.dart';
import 'package:yuva_raithu_app/features/orders/presentation/checkout_screen.dart';

class OrderTrackingScreen extends ConsumerWidget {
  final int orderId;
  final Order? order;

  const OrderTrackingScreen({super.key, required this.orderId, this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (order != null) {
      return _buildContent(context, order!);
    }

    final repo = ref.watch(orderRepositoryProvider);
    return Scaffold(
      backgroundColor: const Color(0xFFF5FFF5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF2E7D32),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Order #$orderId',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<Order>(
        future: repo.getOrderById(orderId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF2E7D32)));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error loading order: ${snapshot.error}'));
          }
          final loadedOrder = snapshot.data;
          if (loadedOrder == null) {
            return const Center(child: Text('Order not found.'));
          }
          return _buildContent(context, loadedOrder);
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, Order ord) {
    final status = ord.status.toUpperCase();
    final isPlaced = true;
    final isConfirmed = status == 'CONFIRMED' || status == 'SHIPPED' || status == 'DELIVERED';
    final isShipped = status == 'SHIPPED' || status == 'DELIVERED';
    final isDelivered = status == 'DELIVERED';
    final isCancelled = status == 'CANCELLED';

    return Scaffold(
      backgroundColor: const Color(0xFFF5FFF5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF2E7D32),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Order #${ord.id}',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isCancelled ? Colors.red.shade50 : const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isCancelled ? Colors.red : const Color(0xFF2E7D32)),
              ),
              child: Row(
                children: [
                  Icon(
                    isCancelled ? Icons.cancel : Icons.check_circle,
                    color: isCancelled ? Colors.red : const Color(0xFF2E7D32),
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Status: ${ord.status}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: isCancelled ? Colors.red.shade900 : const Color(0xFF1B5E20),
                          ),
                        ),
                        Text(
                          'Payment: ${ord.paymentMethod}',
                          style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '₹${ord.totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Order Tracking Stepper
            const Text('Tracking Progress', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  _buildStep(
                    title: 'Order Placed',
                    subtitle: 'Your order has been recorded.',
                    isCompleted: isPlaced && !isCancelled,
                    isActive: status == 'PENDING',
                    isLast: false,
                  ),
                  _buildStep(
                    title: 'Confirmed by Dealer',
                    subtitle: isConfirmed ? 'Order accepted by dealer.' : 'Awaiting confirmation.',
                    isCompleted: isConfirmed,
                    isActive: status == 'CONFIRMED',
                    isLast: false,
                  ),
                  _buildStep(
                    title: 'Dispatched / Out for Delivery',
                    subtitle: isShipped ? 'Items packed and on the way.' : 'Preparing for shipment.',
                    isCompleted: isShipped,
                    isActive: status == 'SHIPPED',
                    isLast: false,
                  ),
                  _buildStep(
                    title: 'Delivered',
                    subtitle: isDelivered ? 'Order safely delivered!' : 'Pending final delivery.',
                    isCompleted: isDelivered,
                    isActive: false,
                    isLast: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Items in this order
            const Text('Order Items', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 12),
            if (ord.items.isEmpty)
              const Text('No item details available.')
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: ord.items.length,
                itemBuilder: (context, idx) {
                  final it = ord.items[idx];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Color(0xFFE8F5E9),
                        child: Icon(Icons.inventory, color: Color(0xFF2E7D32)),
                      ),
                      title: Text(it.productName, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('Qty: ${it.quantity} x ₹${it.priceAtPurchase.toStringAsFixed(2)}'),
                      trailing: Text(
                        '₹${(it.quantity * it.priceAtPurchase).toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
            const SizedBox(height: 20),

            // Delivery Address
            const Text('Delivery Address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Color(0xFF2E7D32)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      ord.deliveryAddress.isNotEmpty ? ord.deliveryAddress : 'Not specified',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep({
    required String title,
    required String subtitle,
    required bool isCompleted,
    bool isActive = false,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isCompleted
                    ? const Color(0xFF2E7D32)
                    : isActive
                        ? Colors.amber.shade700
                        : Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              child: isCompleted
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : isActive
                      ? const Icon(Icons.hourglass_top, size: 14, color: Colors.white)
                      : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 36,
                color: isCompleted ? const Color(0xFF2E7D32) : Colors.grey.shade300,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: isCompleted || isActive ? Colors.black87 : Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 2),
              Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }
}
