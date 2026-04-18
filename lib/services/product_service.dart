import '../models/product.dart';
import '../models/user.dart';
import '../models/review.dart';
import '../data/dummy_data.dart';

class ProductService {
  Future<List<Product>> fetchProducts() async {
    await Future.delayed(const Duration(seconds: 1));
    return DummyData.products;
  }

  Future<Product?> fetchProductById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      return DummyData.products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<Product>> fetchByCategory({
    required String category,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return DummyData.products
        .where((p) => p.category.label.toLowerCase() == category.toLowerCase())
        .toList();
  }

  Future<List<Product>> searchProducts(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));

    return DummyData.products
        .where((product) => product.matchesSearch(query))
        .toList();
  }

  Future<User?> fetchSellerById(String sellerId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      return DummyData.users.firstWhere((u) => u.id == sellerId);
    } catch (e) {
      return null;
    }
  }

  Future<List<Review>> fetchReviewsForSeller(String sellerId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return DummyData.reviews.where((r) => r.sellerId == sellerId).toList();
  }
}