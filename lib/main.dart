import 'package:flutter/material.dart';
import 'package:shoppinglist_app/screens/groceriesscreen.dart';
import 'package:shoppinglist_app/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Groceries',
      theme: theme,
      home: const GroceriesScreen(),
    );
  }
}