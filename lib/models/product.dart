import 'base_model.dart';
import 'enums.dart';
import '../mixins/searchable.dart';

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

  final String? measurements;

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
    this.measurements,
  });

  @override
  List<String> get searchKeywords => [
        title,
        description,
        category.label,
        condition.label,
        size,
        location,
      ];

  String get formattedPrice => '${price.toStringAsFixed(0)} RWF';

  bool get hasMeasurements => measurements != null && measurements!.isNotEmpty;

  String get timeAgo {
    final difference = DateTime.now().difference(createdAt);
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
      'measurements': measurements,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}