import 'package:flutter/material.dart';
import 'package:frontend/screens/catalog_page.dart';
import 'package:frontend/theme/app_theme.dart';
<<<<<<< HEAD
import 'package:frontend/theme/theme_controller.dart';
=======
import 'package:frontend/screens/my_borrowings_screen.dart';
>>>>>>> 042b920d913d8b41afd7e7f25c066d4ace4cf400

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const CatalogPage(),
    const MyBorrowingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, mode, __) {
        return MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: mode,
          home: const CatalogPage(),
        );
      },
=======
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Catalog'),
            BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Second'),
          ],
        ),
      ),
>>>>>>> 042b920d913d8b41afd7e7f25c066d4ace4cf400
    );
  }
}
