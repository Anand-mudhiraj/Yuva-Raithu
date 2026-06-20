import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FFF5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF2E7D32),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Order #YR1025',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Summary Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.shopping_bag, color: Color(0xFF2E7D32), size: 40),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Urea 45kg', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 4),
                        Text('Quantity: 2 Bags', style: TextStyle(color: Colors.grey.shade700, fontSize: 14)),
                        const SizedBox(height: 4),
                        Text('Dealer: Rythu Traders', style: TextStyle(color: Colors.grey.shade700, fontSize: 14)),
                      ],
                    ),
                  ),
                  const Text('₹2400', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Order Tracking Stepper Header
            const Text('Order Tracking', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 16),
            
            // Stepper Container
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  _buildStep(title: 'Order Placed', subtitle: '20 May 2024, 10:30 AM', isCompleted: true, isLast: false),
                  _buildStep(title: 'Dealer Accepted', subtitle: '20 May 2024, 11:15 AM', isCompleted: true, isLast: false),
                  _buildStep(title: 'Out For Delivery', subtitle: '21 May 2024, 09:45 AM', isCompleted: false, isActive: true, isLast: false),
                  _buildStep(title: 'Delivered', subtitle: 'Estimated: 21 May 2024, 05:00 PM', isCompleted: false, isLast: true),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Delivery Address Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Delivery Address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 12),
                        const Text('Ramesh Kumar', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(
                          'H No: 2-123, Village: Lingapur,\nMandal: Nalgonda, Telangana - 508001',
                          style: TextStyle(color: Colors.grey.shade700, height: 1.5),
                        ),
                        const SizedBox(height: 8),
                        const Text('+91 98765 43210', style: TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const Icon(Icons.location_on_outlined, color: Color(0xFF2E7D32), size: 28),
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
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline graphics
          Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted ? const Color(0xFF2E7D32) : (isActive ? Colors.white : Colors.white),
                  border: Border.all(
                    color: isCompleted || isActive ? const Color(0xFF2E7D32) : Colors.grey.shade400,
                    width: 2,
                  ),
                ),
                child: isCompleted
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : (isActive ? const Center(child: Icon(Icons.local_shipping, size: 14, color: Color(0xFF2E7D32))) : null),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: isCompleted ? const Color(0xFF2E7D32) : Colors.grey.shade300,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: isCompleted || isActive ? FontWeight.bold : FontWeight.normal,
                    color: isCompleted || isActive ? Colors.black : Colors.grey.shade600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 24), // Spacing between steps
              ],
            ),
          ),
        ],
      ),
    );
  }
}
