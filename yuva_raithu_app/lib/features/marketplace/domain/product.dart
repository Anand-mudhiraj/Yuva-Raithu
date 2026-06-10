class Product {
  final int id;
  final String name;
  final String brand;
  final double price;
  final String category;
  final String description;
  final String usageInstructions;
  final String benefits;
  final int availableStock;
  final String dealerName;
  final int dealerId;
  final List<String> imageUrls;
  final double averageRating;
  final int totalReviews;

  Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.category,
    required this.description,
    required this.usageInstructions,
    required this.benefits,
    required this.availableStock,
    required this.dealerName,
    required this.dealerId,
    required this.imageUrls,
    required this.averageRating,
    required this.totalReviews,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'] ?? '',
      brand: json['brand'] ?? '',
      price: json['price']?.toDouble() ?? 0.0,
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      usageInstructions: json['usageInstructions'] ?? '',
      benefits: json['benefits'] ?? '',
      availableStock: json['availableStock'] ?? 0,
      dealerName: json['dealerName'] ?? '',
      dealerId: json['dealerId'] ?? 0,
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
      averageRating: json['averageRating']?.toDouble() ?? 0.0,
      totalReviews: json['totalReviews'] ?? 0,
    );
  }
}
