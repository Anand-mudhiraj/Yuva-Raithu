import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yuva_raithu_app/features/marketplace/domain/product.dart';
import 'package:yuva_raithu_app/features/orders/domain/cart_item.dart';

class CartNotifier extends Notifier<List<CartItem>> {
  @override
  List<CartItem> build() {
    return [];
  }

  void addProduct(Product product) {
    final index = state.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      state[index].quantity++;
      state = [...state]; // trigger update
    } else {
      state = [...state, CartItem(product: product)];
    }
  }

  void removeProduct(Product product) {
    state = state.where((item) => item.product.id != product.id).toList();
  }

  void decrementQuantity(Product product) {
    final index = state.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      if (state[index].quantity > 1) {
        state[index].quantity--;
        state = [...state];
      } else {
        removeProduct(product);
      }
    }
  }

  void clearCart() {
    state = [];
  }

  double get totalAmount {
    return state.fold(0, (sum, item) => sum + item.totalPrice);
  }
}

final cartNotifierProvider = NotifierProvider<CartNotifier, List<CartItem>>(() {
  return CartNotifier();
});
