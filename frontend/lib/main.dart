import 'package:flutter/material.dart';
import 'package:frontend/screens/catalog_page.dart';
import 'package:frontend/theme/app_theme.dart';
import 'package:frontend/theme/theme_controller.dart';
import 'package:frontend/screens/my_borrowings_screen.dart';
import 'package:frontend/screens/profile_screen.dart'; // NEW: Profile screen for BottomNav
import 'package:frontend/services/auth_service.dart'; // NEW: Auth Service
import 'package:frontend/screens/login_screen.dart'; // NEW: Login Screen
import 'package:frontend/screens/signup_screen.dart'; // NEW: Sign Up Screen

final ThemeController themeController = ThemeController();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await themeController.load();
  runApp(const MyApp());
}

// --- NEW WIDGET: MyAppHome ---
// This widget handles the authenticated state (Scaffold and BottomNavigationBar)
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

  @override
  void initState() {
    super.initState();
    // Initialize pages based on the provided userRole
    _pages = [
      CatalogPage(userRole: widget.userRole, onLogout: widget.onLogout),
      const MyBorrowingsScreen(), // Assuming this will be role-specific later
      ProfileScreen(userRole: widget.userRole, onLogout: widget.onLogout), // New page
    ];
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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Catalog',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'My Loans',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// --- TEMPORARY FIX: Placeholder for AuthService ---
// This class is added to resolve the "AuthService is unknown" error, 
// assuming the original file 'services/auth_service.dart' is missing 
// or incomplete in this environment.
class AuthService {
  // Simulates fetching the stored role (e.g., from SharedPreferences/local storage)
  Future<String?> getRole() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return null; 
  }

  // Simulates clearing authentication data
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 100));
    print('User logged out.');
  }
}

// --- MAIN WIDGET: MyApp ---
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Now AuthService is defined, so this line should compile without errors.
  final AuthService _authService = AuthService();
  String? _role;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  // Check for existing token/role to restore session
  void _checkAuthStatus() async {
    // This is where the actual AuthService.getRole() would be called.
    // The placeholder implementation is used now.
    final role = await _authService.getRole(); 
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _role = role; // Use the role returned from getRole()
      _isLoading = false;
    });
  }

  // Callback function to handle successful login/registration
  void _handleAuthSuccess(String? newRole) {
    setState(() {
      _role = newRole;
    });
  }

  // Callback function to handle logout
  void _handleLogout() async {
    await _authService.logout(); // Clears local session and optionally notifies backend
    setState(() {
      _role = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Determine the home widget based on authentication status
    Widget homeWidget;

    if (_isLoading) {
      homeWidget = const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    } else if (_role == null) {
      // Not logged in: Show Login screen with ability to navigate to Sign Up
      homeWidget = LoginScreen(onLoginSuccess: _handleAuthSuccess);
    } else {
      // Logged in: Show the main app structure
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
          // Use the determined home widget
          home: homeWidget, 
          // Define routes for navigation
          routes: {
            // Updated to handle Sign Up success correctly.
            // When sign up is successful, we set the new role (which triggers 
            // the main app structure) and then remove the sign-up screen from the stack.
            '/signup': (context) => SignUpScreen(onSignUpSuccess: (role) {
                  _handleAuthSuccess(role); 
                  Navigator.pop(context); // Go back to the main authenticated view
                }),
          },
        );
      },
    );
  }
}