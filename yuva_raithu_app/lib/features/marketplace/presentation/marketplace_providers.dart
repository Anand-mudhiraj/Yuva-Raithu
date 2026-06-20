import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yuva_raithu_app/core/providers.dart';
import 'package:yuva_raithu_app/features/marketplace/data/marketplace_repository.dart';
import 'package:yuva_raithu_app/features/marketplace/domain/product.dart';
import 'package:yuva_raithu_app/features/marketplace/domain/review.dart';

final marketplaceRepositoryProvider = Provider((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return MarketplaceRepository(apiClient);
});

// Provider for fetching all products, by category or by search query
final productsProvider = FutureProvider.family<List<Product>, String>((ref, paramString) async {
  final repository = ref.watch(marketplaceRepositoryProvider);
  
  // Parse the query parameters from the string (e.g. category=SEEDS&query=Urea)
  final uri = Uri.parse('http://dummy.com/?$paramString');
  final category = uri.queryParameters['category'];
  final query = uri.queryParameters['query'];
  
  if (query != null && query.isNotEmpty) {
    return repository.searchProducts(query);
  } else if (category != null && category.isNotEmpty) {
    return repository.getProductsByCategory(category);
  } else {
    return repository.getAllProducts();
  }
});

final productReviewsProvider = FutureProvider.family<List<Review>, int>((ref, productId) async {
  final repository = ref.watch(marketplaceRepositoryProvider);
  return repository.getProductReviews(productId);
});
