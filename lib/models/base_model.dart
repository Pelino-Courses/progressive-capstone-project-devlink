/// Abstract base class for all domain models in PreLoved Market.
/// Provides shared fields: [id] and [createdAt].
/// Every model must implement [toMap] for future database/API integration.
abstract class BaseModel {
  final String id;
  final DateTime createdAt;

  // B4: Constructor with named parameters and required annotations
  BaseModel({
    required this.id,
    required this.createdAt,
  });

  /// Converts the model to a Map for serialization.
  Map<String, dynamic> toMap();

  @override
  String toString() => '${runtimeType}(id: $id)';
}