import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/enums.dart';
import '../theme/app_theme.dart';

/// Custom reusable widget for displaying a product listing card.
/// (C3: Custom widget that accepts parameters, used in 2+ places)
///
/// Used in:
/// - HomeScreen: product grid
/// - SearchResults: filtered product list
///
/// Accepts [product] data and an [onTap] callback for navigation.
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      // C4: Card — Material Design component
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image with condition badge overlay
            // C2: Stack layout — image with badge on top
            Stack(
              children: [
                // Product image
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Container(
                    height: 140,
                    width: double.infinity,
                    color: AppTheme.outline.withOpacity(0.3),
                    child: Image.asset(
                      product.imageUrls.first,
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      // Fallback if image doesn't exist
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(
                            _getCategoryIcon(product.category),
                            size: 48,
                            color: AppTheme.onSurfaceVariant,
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Condition badge — positioned top-right
                Positioned(
                  top: 8,
                  right: 8,
                  child: ConditionBadge(condition: product.condition),
                ),
              ],
            ),

            // Product info section
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product title
                  Text(
                    product.title,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Price
                  Text(
                    product.formattedPrice,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 6),

                  // Size and time info
                  // C2: Row layout
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Size: ${product.size}',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      Text(
                        product.timeAgo,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Returns the appropriate icon for each product category.
  IconData _getCategoryIcon(ProductCategory category) {
    // A4: Switch expression
    return switch (category) {
      ProductCategory.clothes => Icons.checkroom,
      ProductCategory.shoes => Icons.sports_handball,
      ProductCategory.accessories => Icons.watch,
    };
  }
}

// ──────────────────────────────────────────────
// Second reusable widget: ConditionBadge
// Also used independently in ProductDetailScreen
// ──────────────────────────────────────────────

/// Reusable condition badge widget.
/// Displays the item condition with colour-coded background.
/// Used in [ProductCard] and [ProductDetailScreen].
class ConditionBadge extends StatelessWidget {
  final ProductCondition condition;
  final double fontSize;

  const ConditionBadge({
    super.key,
    required this.condition,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _getBadgeColor(),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        condition.label,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
          color: _getBadgeTextColor(),
        ),
      ),
    );
  }

  Color _getBadgeColor() {
    return switch (condition) {
      ProductCondition.likeNew => AppTheme.conditionLikeNew,
      ProductCondition.good => AppTheme.conditionGood,
      ProductCondition.fair => AppTheme.conditionFair,
    };
  }

  Color _getBadgeTextColor() {
    return switch (condition) {
      ProductCondition.likeNew => AppTheme.conditionLikeNewText,
      ProductCondition.good => AppTheme.conditionGoodText,
      ProductCondition.fair => AppTheme.conditionFairText,
    };
  }
}