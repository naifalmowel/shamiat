import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/cart_provider.dart';
import 'providers/language_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/menu_provider.dart';
import 'providers/settings_provider.dart';
import 'screens/home_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/menu_screen.dart' deferred as menu;
import 'screens/contact_screen.dart' deferred as contact; 
import 'widgets/responsive_layout.dart';
import 'widgets/deferred_loader.dart';
import 'dart:ui';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyC0OTLvYlB7xo1VUUFqcvmvdvn3DsScT4s",
        authDomain: "shamiat.firebaseapp.com",
        projectId: "shamiat",
        storageBucket: "shamiat.firebasestorage.app",
        messagingSenderId: "944141429395",
        appId: "1:944141429395:web:034f453403a0ed9c47fb66",
        measurementId: "G-VY27F0N9VG",
      ),
    );
  } catch (e) {
    debugPrint("Firebase initialization failed: $e");
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => MenuProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
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

    const primaryColor = Color(0xFF1B4332); // Deep Green
    const accentColor = Color(0xFFBC8A5F);  // Copper
    const lightBg = Color(0xFFF2F1ED);      // Muted Cream
    const darkBg = Color(0xFF081C15);       // Dark Emerald
    const surfaceDark = Color(0xFF1B2E26);  // Surface Green for Dark Mode

    return MaterialApp(
      title: 'Shamiat - شاميات',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      locale: Locale(langProvider.isArabic ? 'ar' : 'en'),
      builder: (context, child) {
        ErrorWidget.builder = (FlutterErrorDetails details) {
          return Container(
            color: primaryColor,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(color: accentColor),
          );
        };
        return Directionality(textDirection: TextDirection.ltr, child: child!);
      },
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse, PointerDeviceKind.touch,
          PointerDeviceKind.stylus, PointerDeviceKind.trackpad,
        },
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
        ),
        scaffoldBackgroundColor: lightBg,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: primaryColor),
          titleTextStyle: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 20, fontFamily: 'Cairo'),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: primaryColor,
          unselectedItemColor: Colors.grey,
          elevation: 0,
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
          surface: surfaceDark,
        ),
        scaffoldBackgroundColor: darkBg,
        appBarTheme: const AppBarTheme(
          backgroundColor: surfaceDark,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(color: accentColor, fontWeight: FontWeight.bold, fontSize: 20, fontFamily: 'Cairo'),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: surfaceDark,
          selectedItemColor: accentColor,
          unselectedItemColor: Colors.white38,
          elevation: 0,
        ),
      ),
      home: const MaintenanceWrapper(child: MainScreen()),
    );
  }
}

class MaintenanceWrapper extends StatelessWidget {
  final Widget child;
  const MaintenanceWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();
    final langProvider = context.watch<LanguageProvider>();
    final settings = settingsProvider.settings;

    if (settings.isMaintenance) {
      return Scaffold(
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(30),
          decoration: const BoxDecoration(color: Color(0xFF1B4332)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.build_circle_outlined, size: 100, color: Color(0xFFBC8A5F)),
              const SizedBox(height: 30),
              Text(
                langProvider.isArabic ? 'نعتذر عن الإزعاج' : 'Maintenance in Progress',
                style: const TextStyle(color: Color(0xFFBC8A5F), fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              Text(
                langProvider.isArabic ? settings.maintenanceMsgAr : settings.maintenanceMsgEn,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 18),
              ),
            ],
          ),
        ),
      );
    }

    return Stack(
      children: [
        child,
        if (!settings.isOpen)
          Positioned(
            top: 0, left: 0, right: 0,
            child: SafeArea(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red.shade800.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 5)],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.storefront, color: Colors.white, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          langProvider.isArabic ? 'المطعم مغلق حالياً - نعتذر عن استقبال الطلبات' : 'Restaurant is currently closed - orders not accepted now',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate().slideY(begin: -1, end: 0),
            ),
          )
        else if (settings.isBusy)
          Positioned(
            top: 0, left: 0, right: 0,
            child: SafeArea(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade800.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 5)],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: Colors.white, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          langProvider.isArabic ? 'ضغط طلبات عالي - قد يحدث تأخير بسيط' : 'High order volume - expect slight delays',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate().slideY(begin: -1, end: 0),
            ),
          ),
      ],
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
  bool _isInit = false;

  @override
  void initState() {
    super.initState();
    _loadPersistedIndex();
  }

  void _loadPersistedIndex() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _currentIndex = prefs.getInt('current_tab_index') ?? 0;
        _isInit = true;
      });
    }
  }

  void _saveIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('current_tab_index', index);
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInit) {
      return const Scaffold(
        backgroundColor: Color(0xFF1B4332),
        body: Center(child: CircularProgressIndicator(color: Color(0xFFBC8A5F))),
      );
    }

    final List<Widget> screens = [
      HomeScreen(onViewMenu: () => _saveIndex(1)),
      DeferredWidget(loader: menu.loadLibrary, builder: () => menu.MenuScreen()),
      const CartScreen(),
      DeferredWidget(loader: contact.loadLibrary, builder: () => contact.ContactScreen()),
    ];

    return ResponsiveLayout(
      currentIndex: _currentIndex,
      onIndexChanged: _saveIndex,
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
      child: Container(key: ValueKey<int>(currentIndex), child: child),
    );
  }
}
