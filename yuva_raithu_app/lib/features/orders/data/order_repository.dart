import 'package:yuva_raithu_app/core/network/api_client.dart';
import 'package:yuva_raithu_app/features/orders/domain/cart_item.dart';
import 'package:yuva_raithu_app/features/orders/domain/order.dart';

class OrderRepository {
  final ApiClient apiClient;

  OrderRepository(this.apiClient);

  Future<Order> createOrder(List<CartItem> items, String address, String paymentMethod) async {
    try {
      final response = await apiClient.dio.post('/orders', data: {
        'items': items.map((item) => {
          'productId': item.product.id,
          'quantity': item.quantity,
        }).toList(),
        'deliveryAddress': address,
        'paymentMethod': paymentMethod,
      });

      if (response.statusCode == 200) {
        return Order.fromJson(response.data);
      } else {
        throw Exception('Failed to create order');
      }
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  Future<List<Order>> getMyOrders() async {
    try {
      final response = await apiClient.dio.get('/orders/my-orders');
      if (response.statusCode == 200) {
        final List data = response.data;
        return data.map((json) => Order.fromJson(json)).toList();
      }
    } catch (e) {
      throw Exception('Failed to fetch orders: $e');
    }
    return [];
  }

  Future<Order> getOrderById(int orderId) async {
    try {
      final response = await apiClient.dio.get('/orders/$orderId');
      if (response.statusCode == 200) {
        return Order.fromJson(response.data);
      } else {
        throw Exception('Failed to load order');
      }
    } catch (e) {
      throw Exception('Failed to fetch order: $e');
    }
  }

  Future<List<Order>> getAllOrders() async {
    try {
      final response = await apiClient.dio.get('/orders/all');
      if (response.statusCode == 200) {
        final List data = response.data;
        return data.map((json) => Order.fromJson(json)).toList();
      }
    } catch (e) {
      throw Exception('Failed to fetch all orders: $e');
    }
    return [];
  }

  Future<Order> updateOrderStatus(int orderId, String status) async {
    try {
      final response = await apiClient.dio.put(
        '/orders/$orderId/status',
        queryParameters: {'status': status},
      );
      if (response.statusCode == 200) {
        return Order.fromJson(response.data);
      } else {
        throw Exception('Failed to update status');
      }
    } catch (e) {
      throw Exception('Failed to update status: $e');
    }
  }
}
