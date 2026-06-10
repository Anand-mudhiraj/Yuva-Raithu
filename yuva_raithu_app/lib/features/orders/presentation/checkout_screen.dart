import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yuva_raithu_app/core/providers.dart';
import 'package:yuva_raithu_app/features/orders/data/order_repository.dart';
import 'package:yuva_raithu_app/features/orders/presentation/cart_notifier.dart';

final orderRepositoryProvider = Provider((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return OrderRepository(apiClient);
});

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _addressController = TextEditingController();
  String _paymentMethod = 'CASH_ON_DELIVERY';
  bool _isProcessing = false;

  void _placeOrder() async {
    if (_addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a delivery address')));
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final cartItems = ref.read(cartNotifierProvider);
      final repository = ref.read(orderRepositoryProvider);

      await repository.createOrder(cartItems, _addressController.text, _paymentMethod);

      ref.read(cartNotifierProvider.notifier).clearCart();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order placed successfully!')));
        context.go('/orders');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to place order: $e')));
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartNotifier = ref.watch(cartNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Amount: ₹${cartNotifier.totalAmount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            const Text('Delivery Address', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Enter full address'),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            const Text('Payment Method', style: TextStyle(fontWeight: FontWeight.bold)),
            RadioListTile<String>(
              title: const Text('Cash on Delivery'),
              value: 'CASH_ON_DELIVERY',
              groupValue: _paymentMethod,
              onChanged: (value) => setState(() => _paymentMethod = value!),
            ),
            RadioListTile<String>(
              title: const Text('Online Payment (Razorpay)'),
              value: 'RAZORPAY',
              groupValue: _paymentMethod,
              onChanged: (value) => setState(() => _paymentMethod = value!),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isProcessing ? null : _placeOrder,
                child: _isProcessing ? const CircularProgressIndicator(color: Colors.white) : const Text('Place Order'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
