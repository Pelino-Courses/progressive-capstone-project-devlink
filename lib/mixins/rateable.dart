import '../models/review.dart';

/// Mixin that adds rating capability to any model.
/// Classes using this mixin must provide a list of [reviews].
mixin Rateable {
  /// Returns all reviews associated with this entity.
  List<Review> get reviews;

  /// Calculates the average rating from all reviews.
  /// Returns 0.0 if there are no reviews yet.
  double get averageRating {
    // A4: Ternary operator for null/empty check
    return reviews.isEmpty
        ? 0.0
        : reviews.map((r) => r.rating).reduce((a, b) => a + b) /
            reviews.length;
  }

  /// Returns the total number of reviews.
  int get reviewCount => reviews.length; // A2: Arrow syntax function

  /// Returns a text summary of the rating (e.g., "4.5 (12 reviews)").
  String get ratingSummary =>
      '${averageRating.toStringAsFixed(1)} ($reviewCount reviews)';
}