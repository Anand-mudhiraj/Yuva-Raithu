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
final productsProvider = FutureProvider.family<List<Product>, Map<String, String?>>((ref, params) async {
  final repository = ref.watch(marketplaceRepositoryProvider);
  
  if (params['query'] != null && params['query']!.isNotEmpty) {
    return repository.searchProducts(params['query']!);
  } else if (params['category'] != null && params['category']!.isNotEmpty) {
    return repository.getProductsByCategory(params['category']!);
  } else {
    return repository.getAllProducts();
  }
});

final productReviewsProvider = FutureProvider.family<List<Review>, int>((ref, productId) async {
  final repository = ref.watch(marketplaceRepositoryProvider);
  return repository.getProductReviews(productId);
});
