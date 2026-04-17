import 'package:flutter/material.dart';
import 'package:app/utils/utils.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PreLoved Market"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Home Screen"),

          // 👇 THIS IS WHAT YOU ARE TESTING
          Text(formatPrice(price: 8000)),
        ],
      ),
    );
  }
}