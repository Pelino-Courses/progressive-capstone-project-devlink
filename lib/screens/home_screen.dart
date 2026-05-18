import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../theme/app_theme.dart';
import '../utils/app_localizations.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductService _productService = ProductService();
  String _selectedCategory = 'All';
  final int _currentNavIndex = 0;

  final List<String> _categories = ['All', 'Clothes', 'Shoes', 'Accessories'];
  final Map<String, IconData> _categoryIcons = {
    'All': Icons.apps, 'Clothes': Icons.checkroom, 'Shoes': Icons.sports_handball, 'Accessories': Icons.watch,
  };

  void _onNavTap(int index) {
    if (index == 0) return;
    switch (index) {
      case 1: Navigator.pushNamed(context, '/search'); break;
      case 2: Navigator.pushNamed(context, '/chat-list'); break;
      case 3: Navigator.pushNamed(context, '/profile'); break;
      case 4: Navigator.pushNamed(context, '/add-listing'); break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    final loc = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(children: [
              CircleAvatar(radius: 22, backgroundColor: AppTheme.primaryContainer,
                child: Text((user?.displayName ?? 'U')[0].toUpperCase(),
                    style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w700, fontSize: 18))),
              const SizedBox(width: 12),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(loc.get('hello'), style: Theme.of(context).textTheme.labelSmall),
                Text(user?.displayName ?? 'User', style: Theme.of(context).textTheme.titleMedium),
              ]),
              const Spacer(),
              // Cart icon - clickable with tooltip
              Tooltip(
                message: 'Shopping Cart',
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: IconButton(
                    onPressed: () => Navigator.pushNamed(context, '/cart'),
                    icon: const Icon(Icons.shopping_cart_outlined, color: AppTheme.primary),
                  ),
                ),
              ),
            ]),
          ),

          // Search bar - clickable with hover cursor
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/search'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.outline)),
                  child: Row(children: [
                    const Icon(Icons.search, color: AppTheme.onSurfaceVariant),
                    const SizedBox(width: 10),
                    Text(loc.get('search_hint'), style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.onSurfaceVariant)),
                  ]),
                ),
              ),
            ),
          ),

          // Promo banner
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(height: 100, width: double.infinity,
              decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(16)),
              padding: const EdgeInsets.all(20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(loc.get('promo_title'), style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppTheme.onPrimary, fontWeight: FontWeight.w700)),
                Text(loc.get('promo_subtitle'), style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.onPrimary.withAlpha((0.85 * 255).round()))),
              ]),
            ),
          ),

          // Category chips
          SizedBox(height: 50,
            child: ListView.builder(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = cat == _selectedCategory;
                return Padding(padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: MouseRegion(cursor: SystemMouseCursors.click,
                    child: ChoiceChip(
                      label: Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(_categoryIcons[cat], size: 18, color: isSelected ? AppTheme.primary : AppTheme.onSurfaceVariant),
                        const SizedBox(width: 6), Text(cat),
                      ]),
                      selected: isSelected,
                      onSelected: (_) => setState(() => _selectedCategory = cat),
                      selectedColor: AppTheme.primaryContainer, backgroundColor: AppTheme.surface,
                    )));
              }),
          ),

          // Section title with clickable "See all"
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text("Today's Pick", style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 20, fontWeight: FontWeight.w700)),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/search'),
                  child: Text('${loc.get('see_all')} >', style: TextStyle(color: AppTheme.secondary, fontWeight: FontWeight.w600)),
                ),
              ),
            ]),
          ),

          // Product grid
          Expanded(
            child: StreamBuilder<List<Product>>(
              stream: _selectedCategory == 'All'
                  ? _productService.getProducts()
                  : _productService.getProductsByCategory(_selectedCategory.toLowerCase()),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: AppTheme.primary));
                }
                final products = snapshot.data ?? [];
                if (products.isEmpty) {
                  return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Icon(Icons.inventory_2_outlined, size: 64, color: AppTheme.onSurfaceVariant),
                    const SizedBox(height: 12),
                    Text(loc.get('no_products_yet'), style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 12),
                    ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/add-listing'), child: Text(loc.get('post_first_listing'))),
                  ]));
                }
                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.65, crossAxisSpacing: 12, mainAxisSpacing: 12),
                  itemCount: products.length,
                  itemBuilder: (context, index) => ProductCard(
                    product: products[index],
                    onTap: () => Navigator.pushNamed(context, '/product-detail', arguments: products[index]),
                  ),
                );
              },
            ),
          ),
        ]),
      ),
      bottomNavigationBar: BottomNavigationBar(currentIndex: _currentNavIndex, onTap: _onNavTap,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: 'Sell'),
        ]),
    );
  }
}