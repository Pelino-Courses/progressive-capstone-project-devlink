import 'base_model.dart';
import 'review.dart';
import '../mixins/rateable.dart';

class User extends BaseModel with Rateable {
  final String fullName;
  final String email;
  final String campus;
  final bool isVerified;

  final String? phone;
  final String? avatarUrl;

  final List<Review> _reviews;

  User({
    required super.id,
    required super.createdAt,
    required this.fullName,
    required this.email,
    required this.campus,
    this.isVerified = false, // B4: Default value
    this.phone,
    this.avatarUrl,
    List<Review>? reviews,
  }) : _reviews = reviews ?? [];

  @override
  List<Review> get reviews => _reviews;

  /// Adds a new review to this user's profile.
  void addReview(Review review) {
    _reviews.add(review);
  }

  String get displayName => fullName.split(' ').first;

  /// Returns the user's initials for avatar placeholder.
  String get initials {
    final parts = fullName.split(' ');
    // A4: Ternary operator
    return parts.length >= 2
        ? '${parts.first[0]}${parts.last[0]}'.toUpperCase()
        : parts.first[0].toUpperCase();
  }

  bool get hasAvatar => avatarUrl != null && avatarUrl!.isNotEmpty;

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'campus': campus,
      'isVerified': isVerified,
      'phone': phone,
      'avatarUrl': avatarUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}