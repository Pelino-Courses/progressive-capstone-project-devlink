import 'package:flutter/material.dart';
import 'utils/helpers.dart'; // Importing our utility functions

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PreLoved Market',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
      ),
      // home: const HomeScreen(), // 👈 THIS IS THE IMPORTANT PART
    );
  }
}