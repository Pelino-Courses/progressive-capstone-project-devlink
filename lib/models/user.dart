import 'base_model.dart';
import 'review.dart';
import '../mixins/rateable.dart';

/// Represents a user (buyer or seller) in PreLoved Market.
/// Extends [BaseModel] for shared fields (B2: Inheritance).
/// Uses [Rateable] mixin for rating functionality (B3: Mixin).
class User extends BaseModel with Rateable {
  final String fullName;
  final String email;
  final String campus;
  final bool isVerified;

  // A1: Nullable types — optional user info
  final String? phone;
  final String? avatarUrl;

  // A1: Mutable list for reviews (used by Rateable mixin)
  final List<Review> _reviews;

  // B4: Constructor with named parameters, defaults, and required
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
  }) : _reviews = reviews ?? []; // A1: Null coalescing operator (??)

  /// B3: Implementing Rateable mixin — provides reviews list
  @override
  List<Review> get reviews => _reviews;

  /// Adds a new review to this user's profile.
  void addReview(Review review) {
    _reviews.add(review);
  }

  /// Returns the user's display name (first name only).
  /// A2: Arrow syntax function
  String get displayName => fullName.split(' ').first;

  /// Returns the user's initials for avatar placeholder.
  String get initials {
    final parts = fullName.split(' ');
    // A4: Ternary operator
    return parts.length >= 2
        ? '${parts.first[0]}${parts.last[0]}'.toUpperCase()
        : parts.first[0].toUpperCase();
  }

  /// Checks if the user has a profile picture.
  /// A1: Null-safe check with nullable type
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