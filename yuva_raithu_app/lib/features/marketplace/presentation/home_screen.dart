import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yuva_raithu_app/core/providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5FFF5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.menu, size: 28),
                    // Logo and Title
                    Column(
                      children: const [
                        Icon(Icons.park, color: Color(0xFF2E7D32), size: 32),
                        Text(
                          'YUVA RAITHU',
                          style: TextStyle(
                            color: Color(0xFF2E7D32),
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            letterSpacing: 1.2,
                          ),
                        ),
                        Text(
                          'యువ రైతు',
                          style: TextStyle(
                            color: Color(0xFF2E7D32),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const Icon(Icons.notifications_none, size: 28),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // Greeting Profile
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello, ${authState.user?.fullName ?? 'Ramesh'} 👋',
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'What do you need today?',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                    const CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'), // Placeholder for Farmer image
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Voice Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: InkWell(
                  onTap: () => context.push('/voice'), // Voice assistant action
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E7D32),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: Colors.green.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          child: const Icon(Icons.mic, color: Color(0xFF2E7D32), size: 32),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Tap to Speak',
                              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'మాట్లాడండి',
                              style: TextStyle(color: Colors.white70, fontSize: 16),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: TextField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.search, color: Colors.grey),
                      hintText: 'Search for seeds, fertilizers, pesticides...',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        context.push('/products?query=$value');
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Categories Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCategoryItem(context, 'Seeds', 'విత్తనాలు', Icons.grass, 'SEEDS', const Color(0xFFFFF3E0)),
                    _buildCategoryItem(context, 'Fertilizers', 'ఎరువులు', Icons.science, 'FERTILIZERS', const Color(0xFFE8F5E9)),
                    _buildCategoryItem(context, 'Pesticides', 'పురుగుమందులు', Icons.pest_control, 'PESTICIDES', const Color(0xFFFFEBEE)),
                    _buildCategoryItem(context, 'Equipment', 'పరికరాలు', Icons.agriculture, 'EQUIPMENT', const Color(0xFFE3F2FD)),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Menu List
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      _buildMenuItem(Icons.receipt_long, 'My Orders', 'నా ఆర్డర్లు', () => context.push('/orders')),
                      const Divider(height: 1, thickness: 1),
                      _buildMenuItem(Icons.location_on, 'Nearby Dealers', 'సమీప డీలర్స్', () {}),
                      const Divider(height: 1, thickness: 1),
                      _buildMenuItem(Icons.cloud, 'Weather', 'వాతావరణం', () => context.push('/weather')),
                      const Divider(height: 1, thickness: 1),
                      _buildMenuItem(Icons.account_balance, 'Government Schemes', 'ప్రభుత్వ పథకాలు', () {}),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF2E7D32),
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              break; // already on home
            case 1:
              context.push('/products');
              break;
            case 2:
              context.push('/voice');
              break;
            case 3:
              context.push('/orders');
              break;
            case 4:
              context.push('/dealer-dashboard'); // Using this for profile/dashboard for now
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Categories'),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              backgroundColor: Color(0xFF2E7D32),
              child: Icon(Icons.mic, color: Colors.white),
            ),
            label: '',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, String title, String subtitle, IconData icon, String categoryEnum, Color color) {
    return GestureDetector(
      onTap: () => context.push('/products?category=$categoryEnum'),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 32, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          Text(subtitle, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.orange.shade700),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      trailing: Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 14)),
      onTap: onTap,
    );
  }
}
