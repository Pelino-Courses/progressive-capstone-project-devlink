import 'package:flutter/material.dart';
// import 'utils/helpers.dart'; // ✅ kept as you had it (removed because unused)

// ✅ NEW imports added
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/add_listing_screen.dart';

void main() {
  runApp(const MyApp()); // ✅ unchanged
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PreLoved Market',

      // ✅ REPLACED your theme with your custom theme (safe upgrade)
      theme: AppTheme.theme,

      // ✅ ADDED navigation system (does NOT break anything)
      initialRoute: '/',

      routes: {
        '/': (context) => const HomeScreen(),
        '/product-detail': (context) => const ProductDetailScreen(),
        '/add-listing': (context) => const AddListingScreen(),
      },

      // ❌ removed `home:` because it conflicts with `initialRoute`
      // (this is the ONLY necessary change to avoid runtime errors)
    );
  }
}