import 'base_model.dart';

class Review extends BaseModel {
  final String reviewerId;
  final String sellerId;
  final String productId;
  final double rating;
  final String comment;

  Review({
    required super.id,
    required super.createdAt,
    required this.reviewerId,
    required this.sellerId,
    required this.productId,
    required this.rating,
    required this.comment,
  });

  String get starDisplay {
    final fullStars = rating.floor();
    final emptyStars = 5 - fullStars;
    return '${'★' * fullStars}${'☆' * emptyStars}';
  }

  String get formattedDate =>
      '${createdAt.day}/${createdAt.month}/${createdAt.year}';

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'reviewerId': reviewerId,
      'sellerId': sellerId,
      'productId': productId,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}