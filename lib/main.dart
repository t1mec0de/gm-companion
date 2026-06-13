import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const GMCompanionApp());
}

class GMCompanionApp extends StatelessWidget {
  const GMCompanionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GM Companion',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const HomeScreen(),
    );
  }
}
