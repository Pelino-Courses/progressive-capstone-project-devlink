import 'base_model.dart';
import 'enums.dart';
import '../mixins/searchable.dart';

/// Represents a second-hand fashion item listed for sale.
/// Extends [BaseModel] for shared fields (B2: Inheritance).
/// Uses [Searchable] mixin for search functionality (B3: Mixin).
class Product extends BaseModel with Searchable {
  final String title;
  final String description;
  final double price;
  final ProductCategory category;
  final ProductCondition condition;
  final String size;
  final List<String> imageUrls;
  final String sellerId;
  final String location;

  // A1: Nullable type — measurements are optional
  final String? measurements;

  // B4: Constructor with named parameters, required and default values
  Product({
    required super.id,
    required super.createdAt,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.condition,
    required this.size,
    required this.imageUrls,
    required this.sellerId,
    required this.location,
    this.measurements, // Optional — not all sellers provide measurements
  });

  /// B3: Implementing Searchable mixin — provides keywords for search
  @override
  List<String> get searchKeywords => [
        title,
        description,
        category.label,
        condition.label,
        size,
        location,
      ];

  /// Returns a formatted price string in RWF.
  String get formattedPrice => '${price.toStringAsFixed(0)} RWF';

  /// Checks if this product has measurements provided.
  bool get hasMeasurements => measurements != null && measurements!.isNotEmpty;

  /// Returns how long ago this product was posted.
  String get timeAgo {
    final difference = DateTime.now().difference(createdAt);
    // A4: if/else control flow for time formatting
    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'category': category.name,
      'condition': condition.name,
      'size': size,
      'imageUrls': imageUrls,
      'sellerId': sellerId,
      'location': location,
      'measurements': measurements, // A1: Nullable value in map
      'createdAt': createdAt.toIso8601String(),
    };
  }
}