import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../providers/cart_provider.dart';
import '../providers/language_provider.dart';
import '../providers/theme_provider.dart';
import '../data/translations.dart';

class ResponsiveLayout extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final isAr = context.watch<LanguageProvider>().isArabic;
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final accentColor = Theme.of(context).colorScheme.secondary;
    
    final activeItemColor = isDark ? Colors.white : primaryColor;
    final activeIconColor = isDark ? Colors.white : primaryColor;
    
    bool isMobile = MediaQuery.of(context).size.width < 800;

    String getTitle() {
      switch (currentIndex) {
        case 0: return isAr ? 'الرئيسية' : 'Home';
        case 1: return isAr ? 'القائمة' : 'Menu';
        case 2: return isAr ? 'السلة' : 'Cart';
        default: return 'Shamiat';
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65),
        child: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          elevation: 0, // Clean flat look
          centerTitle: isMobile,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(FontAwesomeIcons.utensils, color: activeIconColor, size: 22),
              const SizedBox(width: 12),
              Text(
                isMobile ? getTitle() : 'SHAMIAT - شاميات',
                style: TextStyle(
                  color: activeItemColor,
                  fontWeight: FontWeight.bold,
                  letterSpacing: isMobile ? 0 : 1.5,
                ),
              ),
            ],
          ),
          actions: [
            if (!isMobile) ...[
              _navButton(Translations.getText('home', isAr), 0, context, activeItemColor),
              _navButton(Translations.getText('menu', isAr), 1, context, activeItemColor),
              _buildDesktopCartButton(context, isAr, activeItemColor),
              const SizedBox(width: 10),
              const VerticalDivider(indent: 15, endIndent: 15, width: 20),
            ],
            _buildThemeToggle(context, isDark, activeIconColor),
            _buildLangToggle(context, isAr, activeItemColor),
            const SizedBox(width: 10),
          ],
        ),
      ),
      body: body,
      bottomNavigationBar: isMobile
          ? Container(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05))),
              ),
              child: BottomNavigationBar(
                currentIndex: currentIndex,
                onTap: onIndexChanged,
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
                      child: _buildCartIcon(context, activeIconColor),
                    ),
                    label: Translations.getText('cart', isAr),
                  ),
                ],
              ),
            )
          : null,
    );
  }

  Widget _navButton(String label, int index, BuildContext context, Color activeColor) {
    final isSelected = currentIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return TextButton(
      onPressed: () => onIndexChanged(index),
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

  Widget _buildDesktopCartButton(BuildContext context, bool isAr, Color activeColor) {
    final cart = context.watch<CartProvider>();
    final isSelected = currentIndex == 2;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        ElevatedButton.icon(
          onPressed: () => onIndexChanged(2),
          icon: const FaIcon(FontAwesomeIcons.basketShopping, size: 15),
          label: Text(Translations.getText('cart', isAr)),
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected ? activeColor : (isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05)),
            foregroundColor: isSelected ? (isDark ? Colors.black : Colors.white) : (isDark ? Colors.white : Colors.black87),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        if (cart.itemCount > 0)
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
                '${cart.itemCount}',
                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCartIcon(BuildContext context, Color activeColor) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const FaIcon(FontAwesomeIcons.basketShopping, size: 18),
        Consumer<CartProvider>(
          builder: (context, cart, child) => cart.itemCount > 0
              ? Positioned(
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
                      '${cart.itemCount}',
                      style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : const SizedBox(),
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
