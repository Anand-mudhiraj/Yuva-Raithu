class Review {
  final int id;
  final int productId;
  final String reviewerName;
  final int rating;
  final String comment;
  final String createdAt;

  Review({
    required this.id,
    required this.productId,
    required this.reviewerName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      productId: json['productId'],
      reviewerName: json['reviewerName'] ?? 'Anonymous',
      rating: json['rating'] ?? 5,
      comment: json['comment'] ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }
}
