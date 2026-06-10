class Order {
  final int id;
  final String status;
  final double totalAmount;
  final String deliveryAddress;
  final String paymentMethod;
  final String paymentTransactionId;
  final String createdAt;

  Order({
    required this.id,
    required this.status,
    required this.totalAmount,
    required this.deliveryAddress,
    required this.paymentMethod,
    required this.paymentTransactionId,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      status: json['status'] ?? 'PENDING',
      totalAmount: json['totalAmount']?.toDouble() ?? 0.0,
      deliveryAddress: json['deliveryAddress'] ?? '',
      paymentMethod: json['paymentMethod'] ?? '',
      paymentTransactionId: json['paymentTransactionId'] ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }
}
