import 'package:cloud_firestore/cloud_firestore.dart';
import 'enums.dart';

class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final ProductCategory category;
  final ProductCondition condition;
  final String size;
  final List<String> imageUrls;
  final String sellerId;
  final String sellerName;
  final String location;
  final String? measurements;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.condition,
    required this.size,
    required this.imageUrls,
    required this.sellerId,
    required this.sellerName,
    required this.location,
    this.measurements,
    required this.createdAt,
  });

  String get formattedPrice => '${price.toStringAsFixed(0)} RWF';

  bool get hasMeasurements => measurements != null && measurements!.isNotEmpty;

  String get timeAgo {
    final difference = DateTime.now().difference(createdAt);
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else {
      return 'Just now';
    }
  }

  factory Product.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      category: ProductCategory.values.firstWhere(
        (e) => e.name == data['category'],
        orElse: () => ProductCategory.clothes,
      ),
      condition: ProductCondition.values.firstWhere(
        (e) => e.name == data['condition'],
        orElse: () => ProductCondition.good,
      ),
      size: data['size'] ?? '',
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      sellerId: data['sellerId'] ?? '',
      sellerName: data['sellerName'] ?? '',
      location: data['location'] ?? '',
      measurements: data['measurements'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'category': category.name,
      'condition': condition.name,
      'size': size,
      'imageUrls': imageUrls,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'location': location,
      'measurements': measurements,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}