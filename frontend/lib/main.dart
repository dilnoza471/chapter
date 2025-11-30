import 'package:flutter/material.dart';
import 'package:frontend/screens/catalog_page.dart';
import 'package:frontend/screens/id_entry_screen.dart';
import 'package:frontend/theme/app_theme.dart';
import 'package:frontend/theme/theme_controller.dart';
import 'package:frontend/screens/my_borrowings_screen.dart';
import 'package:frontend/screens/profile_screen.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/screens/signup_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:frontend/screens/favorites_screen.dart';

ThemeController themeController = ThemeController();
void main() async {

WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://dyxbxwhgsnfysrdgalzq.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR5eGJ4d2hnc25meXNyZGdhbHpxIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTkyNDI5NDYsImV4cCI6MTgzMjEwMDU0Nn0.X0dTWCVr-yY_hZoHH1x3O6p8UXx7Z-8c8v8F6N9K4Aw',
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService _authService = AuthService();
  String? _role;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  void _checkAuthStatus() async {
    final role = await _authService.getRole();
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _role = role;
      _isLoading = false;
    });
  }

  void _handleAuthSuccess(String? newRole) {
    setState(() {
      _role = newRole;
    });
  }

  void _handleLogout() async {
    await _authService.logout();
    setState(() {
      _role = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget homeWidget;

    if (_isLoading) {
      homeWidget = const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    } else if (_role == null) {
      homeWidget = LoginScreen(onLoginSuccess: _handleAuthSuccess);
    } else {
      homeWidget = MyAppHome(userRole: _role!, onLogout: _handleLogout);
    }

    return AnimatedBuilder(
      animation: themeController,
      builder: (context, _) {
        return MaterialApp(
          title: 'Library Management System',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeController.mode,
          home: homeWidget,
          routes: {
            '/signup': (context) => SignUpScreen(
              onSignUpSuccess: (role) {
                _handleAuthSuccess(role);
                Navigator.pop(context);
              },
            ),
          },
        );
      },
    );
  }
}

class MyAppHome extends StatefulWidget {
  final String userRole;
  final VoidCallback onLogout;

  const MyAppHome({super.key, required this.userRole, required this.onLogout});

  @override
  State<MyAppHome> createState() => _MyAppHomeState();
}

class _MyAppHomeState extends State<MyAppHome> {
  int _selectedIndex = 0;
  late final List<Widget> _pages;
  late final List<BottomNavigationBarItem> _navItems;

  @override
  void initState() {
    super.initState();
    final isStudent = widget.userRole.toLowerCase() == 'student';

    if (isStudent) {
      _pages = [
        CatalogPage(userRole: widget.userRole, onLogout: widget.onLogout),
        const MyBorrowingsScreen(),
        const FavoritesScreen(),
        ProfileScreen(userRole: widget.userRole, onLogout: widget.onLogout),
      ];
      _navItems = const [
        BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Catalog'),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment),
          label: 'My Loans',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ];
      _selectedIndex = 0; // students start on Catalog
    } else {
      _pages = [
        CatalogPage(userRole: widget.userRole, onLogout: widget.onLogout),
        IdEntryScreen(),
        ProfileScreen(userRole: widget.userRole, onLogout: widget.onLogout),
      ];
      _navItems = const [
        BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Catalog'),
        BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'Borrow'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ];
      _selectedIndex = 1; // librarians start on Borrow page
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Theme.of(context).primaryColor,
        items: _navItems,
      ),
    );
  }
}
