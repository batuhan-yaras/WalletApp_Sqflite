import 'package:flutter/material.dart';
import 'package:wallet_app/login_page.dart';
import 'package:wallet_app/product/all_strings.dart';
import 'package:wallet_app/core/appBarTheme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(appBarTheme: appBar_Theme()),
      title: AllStrings().appTitle,
      home: const LoginPage(),
    );
  }
}
