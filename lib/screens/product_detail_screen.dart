import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/user.dart';
import '../services/product_service.dart';
import '../theme/app_theme.dart';
import '../widgets/product_card.dart';

/// Product Detail Screen — shows full information about a product listing.
/// Receives a [Product] object via route arguments (D2: Data passing).
class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ProductService _productService = ProductService();

  // A1: Nullable variable — seller loaded async
  User? _seller;
  bool _isLoadingSeller = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadSeller();
  }

  /// Loads the seller profile (B5: async/await)
  Future<void> _loadSeller() async {
    final product = ModalRoute.of(context)!.settings.arguments as Product;
    final seller = await _productService.fetchSellerById(product.sellerId);

    if (mounted) {
      setState(() {
        _seller = seller;
        _isLoadingSeller = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // D2: Receiving data passed via route arguments
    final product = ModalRoute.of(context)!.settings.arguments as Product;

    return Scaffold(
      backgroundColor: AppTheme.background,
      // C2: Column layout — vertical screen structure
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable content area
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Top navigation bar ──
                    _buildTopBar(context),

                    // ── Product image ──
                    _buildProductImage(product),

                    // ── Seller info ──
                    _buildSellerInfo(context, product),

                    // ── Product details ──
                    _buildProductDetails(context, product),

                    // ── Description ──
                    _buildDescription(context, product),

                    // ── Posted date ──
                    _buildPostedDate(context, product),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // ── Fixed bottom buttons ──
            _buildBottomButtons(context),
          ],
        ),
      ),
    );
  }

  /// Custom top bar with back and share buttons
  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      // C2: Row layout — back button + spacer + share button
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // D5: Back navigation with Navigator.pop
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: AppTheme.primary),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.share_outlined, color: AppTheme.primary),
          ),
        ],
      ),
    );
  }

  /// Product image with left accent strip
  Widget _buildProductImage(Product product) {
    // C2: Stack — image with decorative side strip
    return Stack(
      children: [
        // Left accent strip
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          child: Container(
            width: 8,
            color: AppTheme.primaryContainer,
          ),
        ),

        // Product image
        Container(
          height: 280,
          width: double.infinity,
          margin: const EdgeInsets.only(left: 8),
          color: AppTheme.outline.withValues(alpha: 0.3),
          child: Image.network(
            product.imageUrls.first,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Icon(
                  Icons.image_outlined,
                  size: 80,
                  color: AppTheme.onSurfaceVariant,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Seller information bar with rating
  Widget _buildSellerInfo(BuildContext context, Product product) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: _isLoadingSeller
          ? const Center(
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          // C2: Row — avatar + name + rating
          : Row(
              children: [
                // Seller avatar
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppTheme.primaryContainer,
                  child: Text(
                    // A1: Null-safe access with fallback
                    _seller?.initials ?? '?',
                    style: const TextStyle(
                      color: AppTheme.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // Seller name and review count
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _seller?.fullName ?? 'Unknown Seller',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      // A1: Using ?. and ?? for null safety
                      '(${_seller?.reviewCount ?? 0} reviews)',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),

                const Spacer(),

                // Star rating display
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 22),
                    const SizedBox(width: 4),
                    Text(
                      _seller?.averageRating.toStringAsFixed(1) ?? '0.0',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  /// Product title, price, condition, and size
  Widget _buildProductDetails(BuildContext context, Product product) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Divider
          Divider(color: AppTheme.outline.withValues(alpha: 0.5)),
          const SizedBox(height: 8),

          // Product title
          Text(
            product.title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),

          // Price
          Text(
            product.formattedPrice,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 12),

          // C2 & C3: Row — condition badge (reused ConditionBadge widget) + size
          Row(
            children: [
              // C3: Reusing ConditionBadge widget from product_card.dart
              ConditionBadge(condition: product.condition, fontSize: 14),
              const SizedBox(width: 16),
              Text(
                'Size: ${product.size}',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),

          // Measurements (if available)
          // A1: Null-safe conditional display
          if (product.hasMeasurements) ...[
            const SizedBox(height: 8),
            Text(
              product.measurements!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.onSurfaceVariant,
                  ),
            ),
          ],
        ],
      ),
    );
  }

  /// Product description section
  Widget _buildDescription(BuildContext context, Product product) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DESCRIPTION:',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            product.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }

  /// Posted date display
  Widget _buildPostedDate(BuildContext context, Product product) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        'Posted ${product.timeAgo}',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontStyle: FontStyle.italic,
            ),
      ),
    );
  }

  /// Fixed bottom section with Message Seller button
  Widget _buildBottomButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border(
          top: BorderSide(color: AppTheme.outline.withValues(alpha: 0.5)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // C4: ElevatedButton — Material Design component
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Chat feature coming in next phase!'),
                  backgroundColor: AppTheme.primary,
                ),
              );
            },
            icon: const Icon(Icons.chat_bubble_outline),
            label: const Text('MESSAGE SELLER'),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {},
            child: Text(
              'Report this listing?',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.secondary,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}