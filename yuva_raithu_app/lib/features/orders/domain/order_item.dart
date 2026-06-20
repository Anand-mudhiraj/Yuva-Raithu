class OrderItem {
  final int id;
  final int productId;
  final String productName;
  final String productBrand;
  final int quantity;
  final double priceAtPurchase;
  final int dealerId;

  OrderItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productBrand,
    required this.quantity,
    required this.priceAtPurchase,
    required this.dealerId,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      productId: json['productId'],
      productName: json['productName'] ?? '',
      productBrand: json['productBrand'] ?? '',
      quantity: json['quantity'] ?? 1,
      priceAtPurchase: json['priceAtPurchase']?.toDouble() ?? 0.0,
      dealerId: json['dealerId'] ?? 0,
    );
  }
}
