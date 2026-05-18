import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product.dart';
import '../services/auth_service.dart';
import '../services/product_service.dart';
import '../theme/app_theme.dart';
import '../utils/app_localizations.dart';
import '../widgets/product_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final user = FirebaseAuth.instance.currentUser;
    final authService = AuthService();
    final productService = ProductService();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(loc.get('profile')),
        actions: [
          Tooltip(
            message: 'Logout',
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(loc.get('logout')),
                    content: Text(loc.get('logout_confirmation')),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx), child: Text(loc.get('cancel'))),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
                        onPressed: () async {
                          await authService.signOut();
                          if (context.mounted) Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                        },
                        child: Text(loc.get('logout')),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(height: 24),
          CircleAvatar(radius: 50, backgroundColor: AppTheme.primaryContainer,
            child: Text((user?.displayName ?? 'U')[0].toUpperCase(),
                style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w700, color: AppTheme.primary))),
          const SizedBox(height: 16),
          Text(user?.displayName ?? 'User', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 4),
          Text(user?.email ?? '', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.onSurfaceVariant)),
          const SizedBox(height: 24),

          // Stats row with real data
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: StreamBuilder<List<Product>>(
              stream: productService.getMyListings(),
              builder: (context, snapshot) {
                final listings = snapshot.data ?? [];
                return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  _statCard(context, '${listings.length}', loc.get('listings'), Icons.inventory_2_outlined, () {
                    if (listings.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(loc.get('post_your_first_item')), backgroundColor: AppTheme.primary));
                    }
                  }),
                  _statCard(context, '0', loc.get('sold'), Icons.sell_outlined, () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(loc.get('no_items_sold_yet')), backgroundColor: AppTheme.primary));
                  }),
                  _statCard(context, '0.0', loc.get('rating'), Icons.star_outline, () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(loc.get('no_ratings_yet')), backgroundColor: AppTheme.primary));
                  }),
                ]);
              },
            ),
          ),
          const SizedBox(height: 24),

          // Menu items - all working
          _menuItem(context, Icons.person_outline, loc.get('edit_profile'), () => Navigator.pushNamed(context, '/edit-profile')),
          _menuItem(context, Icons.location_on_outlined, loc.get('my_addresses'), () => Navigator.pushNamed(context, '/addresses')),
          _menuItem(context, Icons.history, loc.get('purchase_history'), () => Navigator.pushNamed(context, '/purchase-history')),
          _menuItem(context, Icons.settings_outlined, loc.get('settings'), () => Navigator.pushNamed(context, '/settings')),
          _menuItem(context, Icons.help_outline, loc.get('help_support'), () => Navigator.pushNamed(context, '/help')),

          const SizedBox(height: 24),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(alignment: Alignment.centerLeft,
              child: Text(loc.get('my_listings'), style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 20)))),
          const SizedBox(height: 12),

          StreamBuilder<List<Product>>(
            stream: productService.getMyListings(),
            builder: (context, snapshot) {
              final products = snapshot.data ?? [];
              if (products.isEmpty) {
                return Padding(padding: const EdgeInsets.all(24),
                  child: Column(children: [
                    const Icon(Icons.inventory_2_outlined, size: 48, color: AppTheme.onSurfaceVariant),
                    const SizedBox(height: 8),
                    Text('No listings yet', style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 12),
                    ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/add-listing'), child: const Text('Post your first item')),
                  ]));
              }
              return GridView.builder(
                shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.65, crossAxisSpacing: 12, mainAxisSpacing: 12),
                itemCount: products.length,
                itemBuilder: (context, index) => ProductCard(product: products[index],
                    onTap: () => Navigator.pushNamed(context, '/product-detail', arguments: products[index])),
              );
            },
          ),
          const SizedBox(height: 24),
        ]),
      ),
    );
  }

  Widget _statCard(BuildContext context, String value, String label, IconData icon, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.outline)),
          child: Column(children: [
            Icon(icon, color: AppTheme.primary),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppTheme.primary)),
            Text(label, style: Theme.of(context).textTheme.labelSmall),
          ]),
        ),
      ),
    );
  }

  Widget _menuItem(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primary),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right, color: AppTheme.onSurfaceVariant),
        onTap: onTap,
      ),
    );
  }
}