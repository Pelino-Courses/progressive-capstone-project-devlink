abstract class BaseModel {
  final String id;
  final DateTime createdAt;

  // B4: Constructor with named parameters and required annotations
  // B4: Constructor with named parameters and required annotations
  BaseModel({
    required this.id,
    required this.createdAt,
  });

  Map<String, dynamic> toMap();

  @override
  String toString() => '$runtimeType(id: $id)';
}