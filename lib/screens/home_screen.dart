import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../theme/app_theme.dart';
import '../widgets/product_card.dart';

/// Home screen — the main landing page of PreLoved Market.
/// (C1: Home screen reflecting app purpose with real dummy data)
/// (C2: Uses Column, Row, GridView, ListView layout widgets)
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductService _productService = ProductService();

  // A1: Variables with explicit types
  List<Product> _products = [];
  bool _isLoading = true;
  String _selectedCategory = 'All';

  // A1: final variable
  final List<String> _categories = [
    'All',
    'Clothes',
    'Shoes',
    'Accessories',
  ];

  // A3: Map — category to icon mapping
  final Map<String, IconData> _categoryIcons = {
    'All': Icons.apps,
    'Clothes': Icons.checkroom,
    'Shoes': Icons.sports_handball,
    'Accessories': Icons.watch,
  };

  @override
  void initState() {
    super.initState();
    _loadProducts(); // B5: Calling async function
  }

  /// Loads products using ProductService (B5: async/await)
  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);

    // B5: Awaiting Future from ProductService
    final products = await _productService.fetchProducts();

    setState(() {
      _products = products;
      _isLoading = false;
    });
  }

  /// Filters products by selected category
  List<Product> get _filteredProducts {
    // A4: if/else control flow for filtering
    if (_selectedCategory == 'All') {
      return _products;
    } else {
      return _products
          .where((p) =>
              p.category.label.toLowerCase() ==
              _selectedCategory.toLowerCase())
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        // C2: Column layout — main vertical structure
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header Section ──
            _buildHeader(context),

            // ── Search Bar ──
            _buildSearchBar(context),

            // ── Promotional Banner ──
            _buildPromoBanner(context),

            // ── Category Chips ──
            _buildCategoryChips(),

            // ── Section Title ──
            _buildSectionTitle(context),

            // ── Product Grid ──
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.primary,
                      ),
                    )
                  : _buildProductGrid(context),
            ),
          ],
        ),
      ),

      // C4: BottomNavigationBar — Material Design component
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          // A4: Switch for navigation handling
          switch (index) {
            case 4:
              Navigator.pushNamed(context, '/add-listing');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline), label: 'Chat'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'Profile'),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline), label: 'Sell'),
        ],
      ),
    );
  }

  /// Builds the greeting header with user avatar
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      // C2: Row layout — avatar + greeting + cart icon
      child: Row(
        children: [
          // User avatar
          const CircleAvatar(
            radius: 22,
            backgroundColor: AppTheme.primaryContainer,
            child: Icon(Icons.person, color: AppTheme.primary, size: 24),
          ),
          const SizedBox(width: 12),

          // Greeting text
          // C2: Column within Row — stacked text
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello!!',
                style: Theme.of(context).textTheme.labelSmall,
              ),
              Text(
                'Uwamariya',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),

          const Spacer(),

          // Cart icon
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.shopping_cart_outlined,
              color: AppTheme.primary,
              size: 26,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the search bar
  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: () {
          // Could navigate to a search screen
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.outline),
          ),
          // C2: Row — icon + placeholder text
          child: Row(
            children: [
              const Icon(Icons.search, color: AppTheme.onSurfaceVariant),
              const SizedBox(width: 10),
              Text(
                'Search for clothes, shoes...',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the promotional banner card
  Widget _buildPromoBanner(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppTheme.primary,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Get Your FAV',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppTheme.onPrimary,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'in no time. easy access!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.onPrimary.withOpacity(0.85),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds horizontal scrollable category chips
  Widget _buildCategoryChips() {
    return SizedBox(
      height: 50,
      // C2: ListView.builder — horizontal scrollable list
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            // C4: ChoiceChip — Material Design component
            child: ChoiceChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _categoryIcons[category],
                    size: 18,
                    color: isSelected
                        ? AppTheme.primary
                        : AppTheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 6),
                  Text(category),
                ],
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() => _selectedCategory = category);
              },
              selectedColor: AppTheme.primaryContainer,
              backgroundColor: AppTheme.surface,
              labelStyle: TextStyle(
                color: isSelected
                    ? AppTheme.primary
                    : AppTheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? AppTheme.primary : AppTheme.outline,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Builds the "Today's Pick" section title
  Widget _buildSectionTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      // C2: Row — title + "See all" link
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Today's Pick",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              'See all >',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.secondary,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the product grid using GridView
  Widget _buildProductGrid(BuildContext context) {
    final products = _filteredProducts;

    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: AppTheme.onSurfaceVariant),
            const SizedBox(height: 12),
            Text(
              'No products found in this category',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      );
    }

    // C2: GridView.builder — two-column product grid
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];

        // C3: Using custom reusable ProductCard widget
        return ProductCard(
          product: product,
          onTap: () {
            // D2: Passing data between screens
            Navigator.pushNamed(
              context,
              '/product-detail',
              arguments: product,
            );
          },
        );
      },
    );
  }
}