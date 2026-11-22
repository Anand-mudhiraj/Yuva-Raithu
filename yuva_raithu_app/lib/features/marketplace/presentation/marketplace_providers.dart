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
  
  // Safely parse query parameters without URI syntax crashes
  final queryParams = Uri.splitQueryString(paramString);
  final category = queryParams['category'];
  final query = queryParams['query'];
  
  if (query != null && query.trim().isNotEmpty) {
    return repository.searchProducts(query.trim());
  } else if (category != null && category.trim().isNotEmpty) {
    return repository.getProductsByCategory(category.trim());
  } else {
    return repository.getAllProducts();
  }
});

final productReviewsProvider = FutureProvider.family<List<Review>, int>((ref, productId) async {
  final repository = ref.watch(marketplaceRepositoryProvider);
  return repository.getProductReviews(productId);
});

final productByIdProvider = FutureProvider.family<Product, int>((ref, productId) async {
  final repository = ref.watch(marketplaceRepositoryProvider);
  return repository.getProductById(productId);
});
