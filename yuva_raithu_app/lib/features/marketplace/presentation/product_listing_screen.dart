import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:yuva_raithu_app/features/marketplace/presentation/marketplace_providers.dart';
import 'package:yuva_raithu_app/features/marketplace/presentation/widgets/product_card.dart';
import 'package:yuva_raithu_app/features/orders/presentation/cart_notifier.dart';

class ProductListingScreen extends ConsumerStatefulWidget {
  final String? category;
  final String? query;

  const ProductListingScreen({super.key, this.category, this.query});

  @override
  ConsumerState<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends ConsumerState<ProductListingScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'All';
  bool _isConnected = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchQuery = widget.query ?? '';
    _searchController.text = _searchQuery;
    _checkConnectivity();
    
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      if (mounted) {
        setState(() {
          _isConnected = !results.contains(ConnectivityResult.none);
        });
        if (_isConnected) {
          // Trigger a refresh if reconnected
          ref.invalidate(productsProvider);
        }
      }
    });
  }
  
  Future<void> _checkConnectivity() async {
    final results = await Connectivity().checkConnectivity();
    if (mounted) {
      setState(() {
        _isConnected = !results.contains(ConnectivityResult.none);
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isConnected) {
      return _buildOfflineScreen();
    }

    final param = 'category=${widget.category ?? ''}&query=${_searchQuery.isEmpty ? '' : _searchQuery}';
    final productsAsyncValue = ref.watch(productsProvider(param));

    String title = widget.category ?? 'Products';

    return Scaffold(
      backgroundColor: const Color(0xFFEEF7EE),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0A8F2E),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                onPressed: () => context.push('/cart'),
              ),
              Consumer(
                builder: (context, ref, child) {
                  final cartItems = ref.watch(cartNotifierProvider);
                  if (cartItems.isEmpty) return const SizedBox.shrink();
                  return Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text('${cartItems.length}', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: const Color(0xFF0A8F2E),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search products...',
                fillColor: Colors.white,
                filled: true,
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: _searchQuery.isNotEmpty 
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                    )
                  : null,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          // Filter Chips
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All'),
                  _buildFilterChip('High Rating'),
                  _buildFilterChip('Available'),
                  _buildFilterChip('Nearby'),
                ],
              ),
            ),
          ),
          // Product List
          Expanded(
            child: productsAsyncValue.when(
              data: (products) {
                debugPrint("ProductListingScreen: Rendering ${products.length} products.");
                
                // Apply local filters based on selected chip
                var filteredProducts = products;
                if (_selectedFilter == 'High Rating') {
                  filteredProducts = products.where((p) => p.averageRating >= 4.0).toList();
                } else if (_selectedFilter == 'Available') {
                  filteredProducts = products.where((p) => p.availableStock > 0).toList();
                }

                if (filteredProducts.isEmpty) {
                  return _buildEmptyState();
                }
                
                return RefreshIndicator(
                  color: const Color(0xFF0A8F2E),
                  onRefresh: () async {
                    final param = 'category=${widget.category ?? ''}&query=${_searchQuery.isEmpty ? '' : _searchQuery}';
                    ref.invalidate(productsProvider);
                    await ref.read(productsProvider(param).future);
                  },
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredProducts.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return Hero(
                        tag: 'product_${product.id}',
                        child: Material(
                          color: Colors.transparent,
                          child: ProductCard(
                            product: product,
                            onTap: () => context.push('/product/${product.id}', extra: product),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
              loading: () {
                debugPrint("ProductListingScreen: Loading state triggered.");
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF0A8F2E)),
                );
              },
              error: (error, stack) {
                debugPrint("ProductListingScreen: Error state triggered - $error");
                return _buildErrorState(error.toString());
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    bool isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0A8F2E) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? const Color(0xFF0A8F2E) : Colors.grey.shade300),
          boxShadow: isSelected ? [
            BoxShadow(color: const Color(0xFF0A8F2E).withValues(alpha: 0.3), blurRadius: 4, offset: const Offset(0, 2))
          ] : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade700,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          const Text(
            'No products available',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Text(
            'Please check again later or try a different search.',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String errorMsg) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 80, color: Colors.redAccent),
            const SizedBox(height: 16),
            const Text(
              'Unable to load products',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Text(
              'Please check your internet connection or try again.',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => ref.invalidate(productsProvider),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0A8F2E),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text('Retry'),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildOfflineScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF7EE),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A8F2E),
        title: const Text('Offline', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'No Internet Connection',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Please turn on Wi-Fi or Cellular Data.', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _checkConnectivity,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0A8F2E),
                foregroundColor: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
