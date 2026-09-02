import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'providers/language_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/home_screen.dart';
import 'screens/menu_screen.dart';
import 'screens/cart_screen.dart';
import 'widgets/responsive_layout.dart';
import 'dart:ui';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const ShamiatApp(),
    ),
  );
}

class ShamiatApp extends StatelessWidget {
  const ShamiatApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final langProvider = context.watch<LanguageProvider>();

    // Global Premium Palette: Deep Forest Green and Warm Copper
    const primaryColor = Color(0xFF1B4332); // Deep Forest Green
    const accentColor = Color(0xFFBC8A5F); // Warm Copper/Gold
    const lightBg = Color(0xFFFAF9F6); // Soft Cream
    const darkBg = Color(0xFF081C15); // Dark Emerald/Black

    return MaterialApp(
      title: 'Shamiat - شاميات',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      locale: Locale(langProvider.isArabic ? 'ar' : 'en'),
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch, PointerDeviceKind.stylus, PointerDeviceKind.trackpad},
      ),
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Cairo',
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          primary: primaryColor,
          secondary: accentColor,
          surface: Colors.white,
          onSurface: const Color(0xFF1A1A1A),
          background: lightBg,
        ),
        scaffoldBackgroundColor: lightBg,
        textTheme: const TextTheme(
          displayLarge: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
          displayMedium: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(color: Color(0xFF1A1A1A), fontSize: 16),
          bodyMedium: TextStyle(color: Color(0xFF4A4A4A), fontSize: 14),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: primaryColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
          ),
          iconTheme: IconThemeData(color: primaryColor),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: primaryColor,
          unselectedItemColor: Colors.grey,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Cairo',
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: accentColor,
          primary: accentColor,
          secondary: primaryColor,
          surface: const Color(0xFF1B2E26),
          onSurface: Colors.white,
          background: darkBg,
        ),
        scaffoldBackgroundColor: darkBg,
        textTheme: const TextTheme(
          displayLarge: TextStyle(color: accentColor, fontWeight: FontWeight.bold),
          displayMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(color: Colors.white, fontSize: 16),
          bodyMedium: TextStyle(color: Colors.white70, fontSize: 14),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Color(0xFF1B2E26),
          elevation: 0,
          titleTextStyle: TextStyle(
            color: accentColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF1B2E26),
          selectedItemColor: accentColor,
          unselectedItemColor: Colors.white70,
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(onViewMenu: () => setState(() => _currentIndex = 1)),
      const MenuScreen(),
      const CartScreen(),
    ];

    return ResponsiveLayout(
      currentIndex: _currentIndex,
      onIndexChanged: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      body: PageTransitionSwitcher(
        currentIndex: _currentIndex,
        child: screens[_currentIndex],
      ),
    );
  }
}

class PageTransitionSwitcher extends StatelessWidget {
  final int currentIndex;
  final Widget child;

  const PageTransitionSwitcher({
    super.key,
    required this.currentIndex,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
      switchInCurve: Curves.easeInOutCubic,
      switchOutCurve: Curves.easeInOutCubic,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.05, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: Container(
        key: ValueKey<int>(currentIndex),
        child: child,
      ),
    );
  }
}
