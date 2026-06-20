import 'package:flutter/foundation.dart';
import 'package:yuva_raithu_app/core/network/api_client.dart';
import 'package:yuva_raithu_app/features/marketplace/domain/product.dart';
import 'package:yuva_raithu_app/features/marketplace/domain/review.dart';

class MarketplaceRepository {
  final ApiClient apiClient;

  MarketplaceRepository(this.apiClient);

  Future<List<Product>> getAllProducts() async {
    try {
      debugPrint("Fetching all products");
      final response = await apiClient.dio.get('/products');
      if (response.statusCode == 200) {
        final List data = response.data;
        debugPrint("Products loaded: ${data.length}");
        return data.map((json) => Product.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint("Error fetching products: $e");
      throw Exception('Failed to fetch products: $e');
    }
    return [];
  }

  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      final formattedCategory = category.toUpperCase();
      debugPrint("Fetching products for category: $formattedCategory");
      final response = await apiClient.dio.get('/products/category/$formattedCategory');
      if (response.statusCode == 200) {
        final List data = response.data;
        debugPrint("Products loaded: ${data.length}");
        return data.map((json) => Product.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint("Error fetching products for category $category: $e");
      throw Exception('Failed to fetch products for category $category: $e');
    }
    return [];
  }

  Future<List<Product>> searchProducts(String query) async {
    try {
      debugPrint("Searching products for query: $query");
      final response = await apiClient.dio.get('/products/search', queryParameters: {'q': query});
      if (response.statusCode == 200) {
        final List data = response.data;
        debugPrint("Search results loaded: ${data.length}");
        return data.map((json) => Product.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint("Error searching products: $e");
      throw Exception('Failed to search products: $e');
    }
    return [];
  }

  Future<List<Review>> getProductReviews(int productId) async {
    try {
      final response = await apiClient.dio.get('/reviews/product/$productId');
      if (response.statusCode == 200) {
        final List data = response.data;
        return data.map((json) => Review.fromJson(json)).toList();
      }
    } catch (e) {
      throw Exception('Failed to fetch reviews: $e');
    }
    return [];
  }

  Future<Review> addReview(int productId, int rating, String comment) async {
    try {
      final response = await apiClient.dio.post('/reviews', data: {
        'productId': productId,
        'rating': rating,
        'comment': comment,
      });

      if (response.statusCode == 200) {
        return Review.fromJson(response.data);
      } else {
        throw Exception('Failed to add review');
      }
    } catch (e) {
      throw Exception('Failed to add review: $e');
    }
  }

  Future<Product> addProduct({
    required String name,
    required String brand,
    required double price,
    required String category,
    required String description,
    required String usageInstructions,
    required String benefits,
    required int availableStock,
    required List<String> imageUrls,
  }) async {
    try {
      final response = await apiClient.dio.post('/products', data: {
        'name': name,
        'brand': brand,
        'price': price,
        'category': category,
        'description': description,
        'usageInstructions': usageInstructions,
        'benefits': benefits,
        'availableStock': availableStock,
        'imageUrls': imageUrls,
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Product.fromJson(response.data);
      } else {
        throw Exception('Failed to add product');
      }
    } catch (e) {
      throw Exception('Failed to add product: $e');
    }
  }
}
