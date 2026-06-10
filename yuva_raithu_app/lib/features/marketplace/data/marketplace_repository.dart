import 'package:yuva_raithu_app/core/network/api_client.dart';
import 'package:yuva_raithu_app/features/marketplace/domain/product.dart';
import 'package:yuva_raithu_app/features/marketplace/domain/review.dart';

class MarketplaceRepository {
  final ApiClient apiClient;

  MarketplaceRepository(this.apiClient);

  Future<List<Product>> getAllProducts() async {
    try {
      final response = await apiClient.dio.get('/products');
      if (response.statusCode == 200) {
        final List data = response.data;
        return data.map((json) => Product.fromJson(json)).toList();
      }
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
    return [];
  }

  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      final response = await apiClient.dio.get('/products/category/$category');
      if (response.statusCode == 200) {
        final List data = response.data;
        return data.map((json) => Product.fromJson(json)).toList();
      }
    } catch (e) {
      throw Exception('Failed to fetch products for category $category: $e');
    }
    return [];
  }

  Future<List<Product>> searchProducts(String query) async {
    try {
      final response = await apiClient.dio.get('/products/search', queryParameters: {'q': query});
      if (response.statusCode == 200) {
        final List data = response.data;
        return data.map((json) => Product.fromJson(json)).toList();
      }
    } catch (e) {
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
}
