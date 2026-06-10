import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yuva_raithu_app/core/providers.dart';
import 'package:yuva_raithu_app/features/auth/presentation/login_screen.dart';
import 'package:yuva_raithu_app/features/auth/presentation/signup_screen.dart';
import 'package:yuva_raithu_app/features/marketplace/presentation/home_screen.dart';
import 'package:yuva_raithu_app/features/marketplace/presentation/product_listing_screen.dart';
import 'package:yuva_raithu_app/features/marketplace/presentation/product_detail_screen.dart';
import 'package:yuva_raithu_app/features/marketplace/domain/product.dart';
import 'package:yuva_raithu_app/features/orders/presentation/cart_screen.dart';
import 'package:yuva_raithu_app/features/orders/presentation/checkout_screen.dart';
import 'package:yuva_raithu_app/features/orders/presentation/order_history_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isLoggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/signup';
      final isLoggedIn = authState.user != null;

      if (!isLoggedIn && !isLoggingIn) return '/login';
      if (isLoggedIn && isLoggingIn) return '/home';

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/products',
        builder: (context, state) {
          final query = state.uri.queryParameters['query'];
          final category = state.uri.queryParameters['category'];
          return ProductListingScreen(query: query, category: category);
        },
      ),
      GoRoute(
        path: '/product/:id',
        builder: (context, state) {
          // Expecting Product object as extra
          final product = state.extra as Product;
          return ProductDetailScreen(product: product);
        },
      ),
      GoRoute(
        path: '/cart',
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: '/checkout',
        builder: (context, state) => const CheckoutScreen(),
      ),
      GoRoute(
        path: '/orders',
        builder: (context, state) => const OrderHistoryScreen(),
      ),
    ],
  );
});
