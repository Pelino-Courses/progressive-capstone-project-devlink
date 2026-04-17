import 'base_model.dart';

/// Represents a buyer's review of a seller after a transaction.
/// Extends [BaseModel] for shared fields (B2: Inheritance).
class Review extends BaseModel {
  final String reviewerId;
  final String sellerId;
  final String productId;
  final double rating; // 1.0 to 5.0
  final String comment;

  // B4: Constructor with named parameters and required annotations
  Review({
    required super.id,
    required super.createdAt,
    required this.reviewerId,
    required this.sellerId,
    required this.productId,
    required this.rating,
    required this.comment,
  });

  /// Returns star display string (e.g., "★★★★☆").
  String get starDisplay {
    final fullStars = rating.floor();
    final emptyStars = 5 - fullStars;
    return '${'★' * fullStars}${'☆' * emptyStars}';
  }

  /// Returns a formatted date string for display.
  /// A2: Arrow syntax function
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