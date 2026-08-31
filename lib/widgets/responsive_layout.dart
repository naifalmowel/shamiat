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
    bool isMobile = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75),
        child: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          elevation: 2,
          shadowColor: Colors.black12,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          title: Row(
            children: [
              FaIcon(FontAwesomeIcons.utensils, color: isDark ? accentColor : primaryColor, size: 24),
              const SizedBox(width: 15),
              if (!isMobile)
                Text(
                  'SHAMIAT - شاميات',
                  style: TextStyle(
                    color: isDark ? accentColor : primaryColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              if (isMobile)
                Text(
                  isAr ? 'شاميات' : 'Shamiat',
                  style: TextStyle(
                    color: isDark ? accentColor : primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const Spacer(),
              if (!isMobile) ...[
                _navButton(Translations.getText('home', isAr), 0, context, isDark ? accentColor : primaryColor),
                _navButton(Translations.getText('menu', isAr), 1, context, isDark ? accentColor : primaryColor),
                _buildDesktopCartButton(context, isAr, isDark ? accentColor : primaryColor),
              ],
            ],
          ),
          actions: [
            _buildThemeToggle(context, isDark, isDark ? accentColor : primaryColor),
            _buildLangToggle(context, isAr, isDark ? accentColor : primaryColor),
            const SizedBox(width: 15),
          ],
        ),
      ),
      body: body,
      bottomNavigationBar: isMobile
          ? Container(
              decoration: BoxDecoration(
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
                child: BottomNavigationBar(
                  currentIndex: currentIndex,
                  onTap: onIndexChanged,
                  elevation: 0,
                  selectedItemColor: isDark ? accentColor : primaryColor,
                  selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  unselectedLabelStyle: const TextStyle(fontSize: 12),
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
                        child: _buildCartIcon(context, isDark ? accentColor : primaryColor),
                      ),
                      label: Translations.getText('cart', isAr),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }

  Widget _navButton(String label, int index, BuildContext context, Color activeColor) {
    final isSelected = currentIndex == index;
    return TextButton(
      onPressed: () => onIndexChanged(index),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 25),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? activeColor : Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildDesktopCartButton(BuildContext context, bool isAr, Color activeColor) {
    final cart = context.watch<CartProvider>();
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        ElevatedButton.icon(
          onPressed: () => onIndexChanged(2),
          icon: const FaIcon(FontAwesomeIcons.basketShopping, size: 16),
          label: Text(Translations.getText('cart', isAr)),
          style: ElevatedButton.styleFrom(
            backgroundColor: currentIndex == 2 ? activeColor : Colors.black.withValues(alpha: 0.05),
            foregroundColor: currentIndex == 2 ? Colors.white : Theme.of(context).textTheme.bodyLarge?.color,
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
        ),
        if (cart.itemCount > 0)
          Positioned(
            right: -5,
            top: -5,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: activeColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
              child: Text(
                '${cart.itemCount}',
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
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
                      color: activeColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                    child: Text(
                      '${cart.itemCount}',
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
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
      icon: FaIcon(isDark ? FontAwesomeIcons.sun : FontAwesomeIcons.moon, size: 20),
      onPressed: () => context.read<ThemeProvider>().toggleTheme(),
    );
  }

  Widget _buildLangToggle(BuildContext context, bool isAr, Color activeColor) {
    return TextButton(
      onPressed: () => context.read<LanguageProvider>().toggleLanguage(),
      child: Text(
        isAr ? 'EN' : 'العربية',
        style: TextStyle(color: activeColor, fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }
}
