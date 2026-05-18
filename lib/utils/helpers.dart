import '../models/product.dart';
import '../models/enums.dart';

class Helpers {
  Helpers._();

  static const String appName = 'PreLoved Market';
  static const String currency = 'RWF';
  static final DateTime appLaunchDate =
      DateTime(2026, 3, 27);

  static var defaultPageSize = 10;

  // ──────────────────────────────────────────────
  // A2: Function with named parameters
  // ──────────────────────────────────────────────

  /// Formats a price value with currency.
  /// Uses [named parameters] with default value.
  static String formatPrice({
    required double price,
    String currencySymbol = 'RWF',
    bool showDecimals = false,
  }) {
    final formatted = showDecimals
        ? price.toStringAsFixed(2)
        : price.toStringAsFixed(0);
    return '$formatted $currencySymbol';
  }

  // ──────────────────────────────────────────────
  // A2: Arrow syntax function
  // ──────────────────────────────────────────────

  /// Checks if an email is a valid university email.
  static bool isUniversityEmail(String email) =>
      email.endsWith('@ur.ac.rw') || email.endsWith('@stud.ur.ac.rw');

  // ──────────────────────────────────────────────
  // A2: Function with optional positional parameter
  // ──────────────────────────────────────────────

  /// Truncates text to a maximum length.
  static String truncateText(String text, [int maxLength = 50]) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return '${text.substring(0, maxLength)}...';
    }
  }

  // ──────────────────────────────────────────────
  // A1: Null-safe types and operators
  // ──────────────────────────────────────────────

  /// Safely gets a display name from a nullable full name.
  /// Demonstrates ?, ??, and ! operators.
  static String getDisplayName(String? fullName) {
    final name = fullName ?? 'Anonymous User';

    final firstName = name.split(' ').firstOrNull;

    return firstName ?? name;
  }

  // ──────────────────────────────────────────────
  // A4: Switch expression for condition badge color
  // ──────────────────────────────────────────────

  /// Returns the hex color string for a product condition badge.
  static String getConditionColor(ProductCondition condition) {
    return switch (condition) {
      ProductCondition.likeNew => '#B7E4C7',
      ProductCondition.good => '#FADED3',
      ProductCondition.fair => '#FFE8CC',
    };
  }

  // ──────────────────────────────────────────────
  // A4: Switch expression for condition text color
  // ──────────────────────────────────────────────

  /// Returns the text color for a condition badge.
  static String getConditionTextColor(ProductCondition condition) {
    return switch (condition) {
      ProductCondition.likeNew => '#2D6A4F',
      ProductCondition.good => '#C17754',
      ProductCondition.fair => '#A0522D',
    };
  }


  static Map<ProductCategory, List<Product>> groupByCategory(
    List<Product> products,
  ) {
    final Map<ProductCategory, List<Product>> grouped = {};

    for (final product in products) {
      if (grouped.containsKey(product.category)) {
        grouped[product.category]!.add(product);
      } else {
        grouped[product.category] = [product];
      }
    }

    return grouped;
  }

  // ──────────────────────────────────────────────
  // A3: Set — used for unique filter values
  // ──────────────────────────────────────────────

  /// Extracts unique sizes from a list of products.
  static Set<String> getUniqueSizes(List<Product> products) {
    return products.map((p) => p.size).toSet();
  }

  // ──────────────────────────────────────────────
  // A2 & A4: Function combining multiple concepts
  // ──────────────────────────────────────────────

  /// Sorts products based on the given sort criteria.
  /// Demonstrates named parameters and switch control flow.
  static List<Product> sortProducts({
    required List<Product> products,
    String sortBy = 'newest',
  }) {
    final sorted = List<Product>.from(products);

    switch (sortBy) {
      case 'newest':
        sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'price_low':
        sorted.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_high':
        sorted.sort((a, b) => b.price.compareTo(a.price));
        break;
      default:
        break;
    }

    return sorted;
  }

  static String? validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Price is required';
    }

    final price = double.tryParse(value);

    if (price == null) {
      return 'Please enter a valid number';
    } else if (price <= 0) {
      return 'Price must be greater than 0';
    } else if (price > 1000000) {
      return 'Price cannot exceed 1,000,000 $currency';
    }

    return null;
  }
}