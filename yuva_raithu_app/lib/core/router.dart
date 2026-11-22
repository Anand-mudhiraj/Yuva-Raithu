import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yuva_raithu_app/core/providers.dart';
import 'package:yuva_raithu_app/features/auth/presentation/login_screen.dart';
import 'package:yuva_raithu_app/features/auth/presentation/signup_screen.dart';
import 'package:yuva_raithu_app/features/marketplace/presentation/home_screen.dart';
import 'package:yuva_raithu_app/features/marketplace/presentation/product_listing_screen.dart';
import 'package:yuva_raithu_app/features/marketplace/presentation/product_detail_screen.dart';
import 'package:yuva_raithu_app/features/marketplace/presentation/marketplace_providers.dart';
import 'package:yuva_raithu_app/features/marketplace/domain/product.dart';
import 'package:yuva_raithu_app/features/orders/domain/order.dart';
import 'package:yuva_raithu_app/features/orders/presentation/cart_screen.dart';
import 'package:yuva_raithu_app/features/orders/presentation/checkout_screen.dart';
import 'package:yuva_raithu_app/features/orders/presentation/order_history_screen.dart';
import 'package:yuva_raithu_app/features/orders/presentation/order_tracking_screen.dart';
import 'package:yuva_raithu_app/features/voice/presentation/voice_assistant_screen.dart';
import 'package:yuva_raithu_app/features/dealer/presentation/dealer_dashboard_screen.dart';
import 'package:yuva_raithu_app/features/dealer/presentation/add_product_screen.dart';
import 'package:yuva_raithu_app/features/weather/presentation/weather_screen.dart';
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
          if (state.extra is Product) {
            return ProductDetailScreen(product: state.extra as Product);
          }
          final id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
          return Consumer(
            builder: (context, ref, _) {
              final prodAsync = ref.watch(productByIdProvider(id));
              return prodAsync.when(
                data: (prod) => ProductDetailScreen(product: prod),
                loading: () => const Scaffold(
                  body: Center(child: CircularProgressIndicator(color: Color(0xFF2E7D32))),
                ),
                error: (e, _) => Scaffold(
                  appBar: AppBar(title: const Text('Product')),
                  body: Center(child: Text('Product not found: $e')),
                ),
              );
            },
          );
        },
      ),
      GoRoute(
        path: '/order-tracking/:id',
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
          final order = state.extra is Order ? state.extra as Order : null;
          return OrderTrackingScreen(orderId: id, order: order);
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
      GoRoute(
        path: '/voice',
        builder: (context, state) => const VoiceAssistantScreen(),
      ),
      GoRoute(
        path: '/dealer-dashboard',
        builder: (context, state) => const DealerDashboardScreen(),
      ),
      GoRoute(
        path: '/add-product',
        builder: (context, state) => const AddProductScreen(),
      ),
      GoRoute(
        path: '/weather',
        builder: (context, state) => const WeatherScreen(),
      ),
    ],
  );
});
