import 'package:courier_app/feature/courier/presentation/pages/main/main_pages.dart';
import 'package:courier_app/feature/courier/presentation/pages/splash/splash_page.dart';
import 'package:flutter/material.dart';

import 'feature/courier/presentation/pages/main/new_orders/client_location_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashPage(),
    );
  }
}
