import '../models/product.dart';
import '../models/user.dart';
import '../models/review.dart';
import '../data/dummy_data.dart';

/// Service class for loading and managing product data.
/// Uses [Future] and [async/await] to simulate network/database operations.
/// (B5: Async programming)
class ProductService {
  /// Simulates fetching all products from a remote API.
  /// Returns a [Future] that resolves after a 1-second delay.
  Future<List<Product>> fetchProducts() async {
    // B5: Future.delayed simulates network latency
    await Future.delayed(const Duration(seconds: 1));
    return DummyData.products;
  }

  /// Simulates fetching a single product by its [id].
  /// Returns null if the product is not found.
  Future<Product?> fetchProductById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // A4: try/catch for error handling in async context
    try {
      return DummyData.products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null; // A1: Nullable return type
    }
  }

  /// Simulates fetching products filtered by category.
  /// A2: Function with named parameter
  Future<List<Product>> fetchByCategory({
    required String category,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return DummyData.products
        .where((p) => p.category.label.toLowerCase() == category.toLowerCase())
        .toList();
  }

  /// Simulates searching products by query string.
  Future<List<Product>> searchProducts(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));

    // B3: Using Searchable mixin's matchesSearch method
    return DummyData.products
        .where((product) => product.matchesSearch(query))
        .toList();
  }

  /// Simulates fetching a seller's profile with reviews.
  Future<User?> fetchSellerById(String sellerId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      return DummyData.users.firstWhere((u) => u.id == sellerId);
    } catch (e) {
      return null;
    }
  }

  /// Simulates fetching reviews for a specific seller.
  Future<List<Review>> fetchReviewsForSeller(String sellerId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return DummyData.reviews.where((r) => r.sellerId == sellerId).toList();
  }
}