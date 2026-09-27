import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/cart_provider.dart';
import '../providers/language_provider.dart';
import '../providers/theme_provider.dart';
import '../data/translations.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget body;
  final int currentIndex;
  final Function(int) onIndexChanged;

  const ResponsiveLayout({
    super.key,
    required this.body,
    required this.currentIndex,
    required this.onIndexChanged,
  });

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  bool _isSettingsExpanded = false;

  @override
  Widget build(BuildContext context) {
    final langProvider = context.watch<LanguageProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final cart = context.watch<CartProvider>();
    
    final isAr = langProvider.isArabic;
    final isDark = themeProvider.isDarkMode;
    final primaryColor = Theme.of(context).colorScheme.primary;
    
    final activeItemColor = isDark ? Colors.white : primaryColor;
    final activeIconColor = isDark ? Colors.white : primaryColor;
    
    final screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 800;

    // Logic: AppBar is visible on Mobile ONLY for Menu (1) and Cart (2)
    // For Home (0) and Contact (3) it's hidden and settings icon is floating
    bool showAppBar = !isMobile || (widget.currentIndex == 1 || widget.currentIndex == 2);

    String getTitle() {
      switch (widget.currentIndex) {
        case 0: return Translations.getText('home', isAr);
        case 1: return Translations.getText('menu', isAr);
        case 2: return Translations.getText('cart', isAr);
        case 3: return Translations.getText('contact', isAr);
        default: return 'Shamiat';
      }
    }

    return Directionality(
      textDirection: TextDirection.ltr, // Forced LTR globally
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: showAppBar 
            ? PreferredSize(
                preferredSize: const Size.fromHeight(65),
                child: AppBar(
                  backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
                  elevation: 0,
                  centerTitle: true,
                  // Fixed width container for Title to prevent shifting when actions change size
                  title: SizedBox(
                    width: 200, 
                    child: Center(
                      child: Text(
                        isMobile ? getTitle() : 'SHAMIAT - شاميات',
                        style: TextStyle(
                          color: activeItemColor,
                          fontWeight: FontWeight.bold,
                          letterSpacing: isMobile ? 0 : 1.5,
                        ),
                      ),
                    ),
                  ),
                  actions: [
                    if (!isMobile) ...[
                      _navButton(Translations.getText('home', isAr), 0, context, activeItemColor),
                      _navButton(Translations.getText('menu', isAr), 1, context, activeItemColor),
                      _navButton(Translations.getText('contact', isAr), 3, context, activeItemColor),
                      _buildDesktopCartButton(context, isAr, activeItemColor, cart.itemCount),
                      const SizedBox(width: 10),
                      const VerticalDivider(indent: 15, endIndent: 15, width: 20),
                      _buildThemeToggle(context, isDark, activeIconColor),
                      _buildLangToggle(context, isAr, activeItemColor),
                    ] else ...[
                      _buildMobileSettings(context, isAr, isDark, activeIconColor),
                    ],
                    const SizedBox(width: 10),
                  ],
                ),
              )
            : null,
        body: Stack(
          children: [
            Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: isMobile ? double.infinity : 1200,
                ),
                child: widget.body,
              ),
            ),
            // Floating Settings for screens with hidden AppBar on Mobile
            if (isMobile && !showAppBar)
              Positioned(
                top: MediaQuery.of(context).padding.top + 10,
                right: 15,
                child: _buildMobileSettings(context, isAr, isDark, Colors.white, withBackground: true),
              ),
          ],
        ),
        bottomNavigationBar: isMobile
            ? Container(
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05))),
                ),
                child: BottomNavigationBar(
                  currentIndex: widget.currentIndex,
                  onTap: widget.onIndexChanged,
                  elevation: 0,
                  backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
                  selectedItemColor: activeItemColor,
                  unselectedItemColor: isDark ? Colors.white38 : Colors.grey,
                  selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, fontFamily: 'Cairo'),
                  unselectedLabelStyle: const TextStyle(fontSize: 11, fontFamily: 'Cairo'),
                  type: BottomNavigationBarType.fixed,
                  items: [
                    BottomNavigationBarItem(
                      icon: const Padding(
                        padding: EdgeInsets.only(bottom: 4),
                        child: FaIcon(FontAwesomeIcons.house, size: 18),
                      ),
                      label: Translations.getText('home', isAr),
                    ),
                    BottomNavigationBarItem(
                      icon: const Padding(
                        padding: EdgeInsets.only(bottom: 4),
                        child: FaIcon(FontAwesomeIcons.utensils, size: 18),
                      ),
                      label: Translations.getText('menu', isAr),
                    ),
                    BottomNavigationBarItem(
                      icon: Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: _buildMobileCartIcon(cart.itemCount, activeIconColor),
                      ),
                      label: Translations.getText('cart', isAr),
                    ),
                    BottomNavigationBarItem(
                      icon: const Padding(
                        padding: EdgeInsets.only(bottom: 4),
                        child: FaIcon(FontAwesomeIcons.headset, size: 18),
                      ),
                      label: Translations.getText('contact', isAr),
                    ),
                  ],
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildMobileSettings(BuildContext context, bool isAr, bool isDark, Color activeColor, {bool withBackground = false}) {
    return Container(
      padding: withBackground ? const EdgeInsets.symmetric(horizontal: 4, vertical: 4) : null,
      decoration: withBackground ? BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(30),
      ) : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isSettingsExpanded) ...[
            _buildThemeToggle(context, isDark, activeColor)
                .animate()
                .fadeIn(duration: 200.ms)
                .scale(delay: 50.ms)
                .moveX(begin: 15, end: 0),
            _buildLangToggle(context, isAr, activeColor)
                .animate()
                .fadeIn(duration: 200.ms)
                .scale()
                .moveX(begin: 10, end: 0),
          ],
          IconButton(
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
            icon: AnimatedRotation(
              turns: _isSettingsExpanded ? 0.25 : 0,
              duration: const Duration(milliseconds: 300),
              child: FaIcon(
                _isSettingsExpanded ? FontAwesomeIcons.xmark : FontAwesomeIcons.gear,
                size: 18,
                color: activeColor,
              ),
            ),
            onPressed: () => setState(() => _isSettingsExpanded = !_isSettingsExpanded),
          ),
        ],
      ),
    );
  }

  Widget _navButton(String label, int index, BuildContext context, Color activeColor) {
    final isSelected = widget.currentIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return TextButton(
      onPressed: () => widget.onIndexChanged(index),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? activeColor : (isDark ? Colors.white60 : Colors.black54),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _buildDesktopCartButton(BuildContext context, bool isAr, Color activeColor, int count) {
    final isSelected = widget.currentIndex == 2;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        ElevatedButton.icon(
          onPressed: () => widget.onIndexChanged(2),
          icon: const FaIcon(FontAwesomeIcons.basketShopping, size: 15),
          label: Text(Translations.getText('cart', isAr)),
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected ? activeColor : (isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05)),
            foregroundColor: isSelected ? (isDark ? Colors.black : Colors.white) : (isDark ? Colors.white : Colors.black87),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        if (count > 0)
          Positioned(
            right: -5,
            top: -5,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              constraints: const BoxConstraints(minWidth: 22, minHeight: 22),
              child: Text(
                '$count',
                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMobileCartIcon(int count, Color activeColor) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const FaIcon(FontAwesomeIcons.basketShopping, size: 18),
        if (count > 0)
          Positioned(
            right: -10,
            top: -10,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                '$count',
                style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildThemeToggle(BuildContext context, bool isDark, Color activeColor) {
    return IconButton(
      icon: FaIcon(isDark ? FontAwesomeIcons.sun : FontAwesomeIcons.moon, size: 18, color: isDark ? Colors.white70 : activeColor),
      onPressed: () => context.read<ThemeProvider>().toggleTheme(),
    );
  }

  Widget _buildLangToggle(BuildContext context, bool isAr, Color activeColor) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextButton(
      onPressed: () => context.read<LanguageProvider>().toggleLanguage(),
      child: Text(
        isAr ? 'EN' : 'العربية',
        style: TextStyle(color: isDark ? Colors.white70 : activeColor, fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }
}
