import '../models/review.dart';

mixin Rateable {
  List<Review> get reviews;

  double get averageRating {
    return reviews.isEmpty
        ? 0.0
        : reviews.map((r) => r.rating).reduce((a, b) => a + b) /
            reviews.length;
  }

  int get reviewCount => reviews.length;

  String get ratingSummary =>
      '${averageRating.toStringAsFixed(1)} ($reviewCount reviews)';
}