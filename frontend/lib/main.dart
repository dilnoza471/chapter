import 'package:flutter/material.dart';
import 'package:frontend/screens/catalog_page.dart';
import 'package:frontend/screens/id_entry_screen.dart';
import 'package:frontend/screens/add_book_screen.dart'; // NEW IMPORT
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/app_theme.dart';
import 'package:frontend/theme/theme_controller.dart';
import 'package:frontend/screens/MyBorrowingsScreen.dart';
import 'package:frontend/screens/profile_screen.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/screens/signup_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:frontend/screens/favorites_screen.dart';
import 'package:frontend/screens/notifications_screen.dart'; // new
import 'package:frontend/services/notification_service.dart';

ThemeController themeController = ThemeController();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final notificationService = NotificationService();
  await notificationService.initialize();
 

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://dyxbxwhgsnfysrdgalzq.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR5eGJ4d2hnc25meXNyZGdhbHpxIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTkyNDI5NDYsImV4cCI6MTgzMjEwMDU0Nn0.X0dTWCVr-yY_hZoHH1x3O6p8UXx7Z-8c8v8F6N9K4Aw',
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
  String? _pendingIsbn;
  late List<Widget> _pages;
  late final List<BottomNavigationBarItem> _navItems;

  @override
  void initState() {
    super.initState();
    final isStudent = widget.userRole.toLowerCase() == 'student';

    if (isStudent) {
      _pages = [
        CatalogPage(userRole: widget.userRole, onLogout: widget.onLogout),
        MyBorrowingsScreen(),
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
      // LIBRARIAN NAVIGATION - NOW WITH ADD BOOK PAGE
      _pages = [
        CatalogPage(
          userRole: widget.userRole,
          onLogout: widget.onLogout,
          onRequestBorrow: _handleRequestBorrow,
        ),
        IdEntryScreen(bookIsbn: _pendingIsbn),
        const AddBookScreen(),
        ProfileScreen(userRole: widget.userRole, onLogout: widget.onLogout),
      ];
      _navItems = const [
        BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Catalog'),
        BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'Borrow'),
        BottomNavigationBarItem(
          icon: Icon(Icons.library_add),
          label: 'Add Book',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ];
      _selectedIndex = 1; // librarians start on Borrow page
    }
  }

  // called from CatalogPage when BookDetailsPage requests opening Borrow tab
  void _handleRequestBorrow(String isbn) {
    setState(() {
      _pendingIsbn = isbn;
      _selectedIndex = 1; // Borrow tab index for librarians
      // Rebuild pages so BorrowBookPage gets updated prefillIsbn
      final isStudent = widget.userRole.toLowerCase() == 'student';
      if (!isStudent) {
        _pages = [
          CatalogPage(
            userRole: widget.userRole,
            onLogout: widget.onLogout,
            onRequestBorrow: _handleRequestBorrow,
          ),
          IdEntryScreen(bookIsbn: _pendingIsbn),
          const AddBookScreen(),
          ProfileScreen(userRole: widget.userRole, onLogout: widget.onLogout),
        ];
      }
      // ensure selectedIndex remains valid after changing pages
      _selectedIndex = _safeIndex(_selectedIndex);
    });
  }

  int _safeIndex(int idx) {
    if (_pages.isEmpty) return 0;
    if (idx < 0) return 0;
    if (idx >= _pages.length) return _pages.length - 1;
    return idx;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = _safeIndex(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages.isEmpty
          ? const SizedBox.shrink()
          : _pages[_safeIndex(_selectedIndex)],
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NotificationsScreen()),
          );
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            const Icon(Icons.notifications),
            Positioned(
              right: -1,
              top: -1,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: AppColors.destructive,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                child: const Text(
                  '3', // TODO: replace with dynamic count
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _safeIndex(_selectedIndex),
        onTap: _onItemTapped,
        selectedItemColor: Theme.of(context).primaryColor,
        items: _navItems,
      ),
    );
  }
}

class ModernNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<BottomNavigationBarItem> items;

  const ModernNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.foreground.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final item = items[index];
          final bool selected = index == currentIndex;

          return GestureDetector(
            onTap: () => onTap(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.primary.withOpacity(0.15)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconTheme.merge(
                    data: IconThemeData(
                      color: selected
                          ? AppColors.primary
                          : AppColors.foreground,
                      size: 26,
                    ),
                    child: item.icon,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.label!,
                    style: TextStyle(
                      fontSize: 12,
                      color: selected
                          ? AppColors.primary
                          : AppColors.foreground.withOpacity(0.7),
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
