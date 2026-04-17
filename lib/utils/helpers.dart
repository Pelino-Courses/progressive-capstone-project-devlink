import '../models/product.dart';
import '../models/enums.dart';

/// Utility functions and helpers for PreLoved Market.
/// This file demonstrates Dart fundamentals (Section A).
///
/// A1: Variables with explicit types, var, final/const, null-safe types
/// A2: Functions with named/optional parameters and arrow syntax
/// A3: List, Map, Set usage
/// A4: Control flow: if/else, switch, ternary

class Helpers {
  Helpers._(); // Private constructor — utility class

  // ──────────────────────────────────────────────
  // A1: Variables — explicit types, final, const
  // ──────────────────────────────────────────────

  static const String appName = 'PreLoved Market'; // const: compile-time constant
  static const String currency = 'RWF';            // const: never changes
  static final DateTime appLaunchDate =             // final: set once at runtime
      DateTime(2026, 3, 27);

  // A1: var — type inferred by compiler
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
    // A4: Ternary operator for conditional formatting
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
      email.endsWith('@ur.ac.rw') || email.endsWith('@student.ur.ac.rw');

  // ──────────────────────────────────────────────
  // A2: Function with optional positional parameter
  // ──────────────────────────────────────────────

  /// Truncates text to a maximum length.
  static String truncateText(String text, [int maxLength = 50]) {
    // A4: if/else control flow
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
    // A1: ?? (null coalescing) — fallback if null
    final name = fullName ?? 'Anonymous User';

    // A1: ? (null-safe access) on split result
    final firstName = name.split(' ').firstOrNull;

    // A1: ?? again for double safety
    return firstName ?? name;
  }

  // ──────────────────────────────────────────────
  // A4: Switch expression for condition badge color
  // ──────────────────────────────────────────────

  /// Returns the hex color string for a product condition badge.
  static String getConditionColor(ProductCondition condition) {
    // A4: Switch expression (Dart 3 feature)
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

  // ──────────────────────────────────────────────
  // A3: Map — used for filtering/grouping
  // ──────────────────────────────────────────────

  /// Groups a list of products by their category.
  /// Returns a Map where keys are categories and values are product lists.
  static Map<ProductCategory, List<Product>> groupByCategory(
    List<Product> products,
  ) {
    // A3: Map creation and population
    final Map<ProductCategory, List<Product>> grouped = {};

    for (final product in products) {
      // A4: if/else to check and initialize map entry
      if (grouped.containsKey(product.category)) {
        grouped[product.category]!.add(product); // A1: ! (null assertion)
      } else {
        grouped[product.category] = [product]; // A3: List literal
      }
    }

    return grouped;
  }

  // ──────────────────────────────────────────────
  // A3: Set — used for unique filter values
  // ──────────────────────────────────────────────

  /// Extracts unique sizes from a list of products.
  static Set<String> getUniqueSizes(List<Product> products) {
    // A3: Set — automatically removes duplicates
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
    final sorted = List<Product>.from(products); // A3: List copy

    // A4: Switch statement for sort logic
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
        // No sorting applied
        break;
    }

    return sorted;
  }

  /// Validates a price input string.
  /// Returns null if valid, or an error message if invalid.
  static String? validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Price is required';
    }

    final price = double.tryParse(value);

    // A4: if/else chain for validation
    if (price == null) {
      return 'Please enter a valid number';
    } else if (price <= 0) {
      return 'Price must be greater than 0';
    } else if (price > 1000000) {
      return 'Price cannot exceed 1,000,000 $currency';
    }

    return null; // Valid
  }
}