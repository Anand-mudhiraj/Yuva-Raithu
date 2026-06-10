import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yuva_raithu_app/features/marketplace/presentation/marketplace_providers.dart';
import 'package:yuva_raithu_app/features/marketplace/presentation/widgets/product_card.dart';

class ProductListingScreen extends ConsumerWidget {
  final String? category;
  final String? query;

  const ProductListingScreen({super.key, this.category, this.query});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsyncValue = ref.watch(productsProvider({
      'category': category,
      'query': query,
    }));

    String title = 'Products';
    if (query != null && query!.isNotEmpty) {
      title = 'Search: $query';
    } else if (category != null && category!.isNotEmpty) {
      title = category!;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Filter logic placeholder
            },
          )
        ],
      ),
      body: productsAsyncValue.when(
        data: (products) {
          if (products.isEmpty) {
            return const Center(child: Text('No products found.'));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCard(
                product: product,
                onTap: () => context.push('/product/${product.id}', extra: product),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
