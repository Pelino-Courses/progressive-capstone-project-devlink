import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/enums.dart';
import '../theme/app_theme.dart';

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
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Container(
                    height: 140,
                    width: double.infinity,
                    color: AppTheme.outline.withValues(alpha: 0.3),
                    child: product.imageUrls.first.startsWith('http')
                        ? Image.network(
                            product.imageUrls.first,
                            height: 140,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Center(
                              child: Icon(
                                _getCategoryIcon(product.category),
                                size: 48,
                                color: AppTheme.onSurfaceVariant,
                              ),
                            ),
                          )
                        : Image.asset(
                            product.imageUrls.first,
                            height: 140,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Center(
                              child: Icon(
                                _getCategoryIcon(product.category),
                                size: 48,
                                color: AppTheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                  ),
                ),

                Positioned(
                  top: 8,
                  right: 8,
                  child: ConditionBadge(condition: product.condition),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.formattedPrice,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 6),
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

  IconData _getCategoryIcon(ProductCategory category) {
    return switch (category) {
      ProductCategory.clothes => Icons.checkroom,
      ProductCategory.shoes => Icons.sports_handball,
      ProductCategory.accessories => Icons.watch,
    };
  }
}


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