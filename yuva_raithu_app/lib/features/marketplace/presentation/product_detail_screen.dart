import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yuva_raithu_app/features/marketplace/domain/product.dart';
import 'package:yuva_raithu_app/features/orders/presentation/cart_notifier.dart';
import 'package:yuva_raithu_app/features/marketplace/presentation/marketplace_providers.dart';
import 'package:yuva_raithu_app/features/marketplace/domain/review.dart';

class ProductDetailScreen extends ConsumerWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Gallery placeholder
            Container(
              height: 250,
              width: double.infinity,
              color: Colors.grey[200],
              child: product.imageUrls.isNotEmpty
                  ? Image.network(product.imageUrls.first, fit: BoxFit.cover)
                  : const Icon(Icons.image, size: 100, color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.brand,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.name,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '₹${product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.orange),
                          Text('${product.averageRating} (${product.totalReviews} reviews)'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  const Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(product.description.isEmpty ? 'No description available.' : product.description),
                  const SizedBox(height: 16),
                  const Text('Usage Instructions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(product.usageInstructions.isEmpty ? 'Not provided.' : product.usageInstructions),
                  const SizedBox(height: 16),
                  const Text('Benefits', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(product.benefits.isEmpty ? 'Not provided.' : product.benefits),
                  const SizedBox(height: 24),
                  Text('Sold by: ${product.dealerName}', style: const TextStyle(fontStyle: FontStyle.italic)),
                  const SizedBox(height: 24),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Reviews', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      TextButton(
                        onPressed: () => _showAddReviewSheet(context, ref),
                        child: const Text('Add Review'),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildReviewsList(ref),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        ref.read(cartNotifierProvider.notifier).addProduct(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Added to cart!')),
                        );
                      },
                      child: const Text('Add to Cart', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewsList(WidgetRef ref) {
    final reviewsAsync = ref.watch(productReviewsProvider(product.id));

    return reviewsAsync.when(
      data: (reviews) {
        if (reviews.isEmpty) return const Text('No reviews yet. Be the first to review!');
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            final review = reviews[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(review.reviewerName, style: const TextStyle(fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            const Icon(Icons.star, size: 14, color: Colors.orange),
                            Text(review.rating.toString(), style: const TextStyle(fontSize: 12)),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(review.comment),
                    const SizedBox(height: 4),
                    Text(review.createdAt, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Text('Error loading reviews: $err'),
    );
  }

  void _showAddReviewSheet(BuildContext context, WidgetRef ref) {
    int rating = 5;
    final commentController = TextEditingController();
    bool isSubmitting = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Write a Review', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < rating ? Icons.star : Icons.star_border,
                          color: Colors.orange,
                          size: 32,
                        ),
                        onPressed: () => setState(() => rating = index + 1),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: commentController,
                    decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Share your experience...'),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isSubmitting
                          ? null
                          : () async {
                              setState(() => isSubmitting = true);
                              try {
                                final repo = ref.read(marketplaceRepositoryProvider);
                                await repo.addReview(product.id, rating, commentController.text);
                                ref.invalidate(productReviewsProvider(product.id));
                                if (ctx.mounted) Navigator.pop(ctx);
                              } catch (e) {
                                if (ctx.mounted) {
                                  ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(e.toString())));
                                }
                              } finally {
                                if (ctx.mounted) setState(() => isSubmitting = false);
                              }
                            },
                      child: isSubmitting ? const CircularProgressIndicator(color: Colors.white) : const Text('Submit Review'),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
