import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'theme/app_theme.dart';
import 'theme/theme_provider.dart';
import 'utils/app_localizations.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/home_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/add_listing_screen.dart';
import 'screens/chat_list_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/search_screen.dart';
import 'screens/profile/sub_screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const PreLovedMarketApp());
}

class PreLovedMarketApp extends StatefulWidget {
  const PreLovedMarketApp({super.key});

  @override
  State<PreLovedMarketApp> createState() => _PreLovedMarketAppState();
}

class _PreLovedMarketAppState extends State<PreLovedMarketApp> {
  final ThemeProvider _themeProvider = ThemeProvider();
  final LocaleProvider _localeProvider = LocaleProvider();

  @override
  void initState() {
    super.initState();
    _themeProvider.addListener(() => setState(() {}));
    _localeProvider.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PreLoved Market',
      debugShowCheckedModeBanner: false,
      theme: _themeProvider.theme,
      locale: _localeProvider.locale,
      supportedLocales: const [Locale('en'), Locale('fr'), Locale('rw')],
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const AuthWrapper(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/home': (context) => const HomeScreen(),
        '/product-detail': (context) => const ProductDetailScreen(),
        '/add-listing': (context) => const AddListingScreen(),
        '/chat-list': (context) => const ChatListScreen(),
        '/chat': (context) => const ChatScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/search': (context) => const SearchScreen(),
        '/cart': (context) => const CartScreen(),
        '/edit-profile': (context) => const EditProfileScreen(),
        '/addresses': (context) => const AddressesScreen(),
        '/purchase-history': (context) => const PurchaseHistoryScreen(),
        '/settings': (context) => SettingsScreen(
              themeProvider: _themeProvider,
              localeProvider: _localeProvider,
            ),
        '/help': (context) => const HelpScreen(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.checkroom, size: 60, color: AppTheme.primary),
                const SizedBox(height: 16),
                const Text('PreLoved Market', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppTheme.primary)),
                const SizedBox(height: 24),
                const CircularProgressIndicator(color: AppTheme.primary),
              ]),
            ),
          );
        }
        if (snapshot.hasData) return const HomeScreen();
        return const LoginScreen();
      },
    );
  }
}