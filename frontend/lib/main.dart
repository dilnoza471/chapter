import 'package:flutter/material.dart';
import 'package:frontend/screens/catalog_page.dart';
import 'package:frontend/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme,      //  Use our custom light theme
      darkTheme: AppTheme.darkTheme,   //  Use our custom dark theme
      themeMode: ThemeMode.system,     //  Automatically switch by system
      home: const CatalogPage(),
    );
  }
}

