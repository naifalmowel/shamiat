import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../providers/cart_provider.dart';

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
    bool isMobile = MediaQuery.of(context).size.width < 800;

    if (isMobile) {
      return Scaffold(
        body: body,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onIndexChanged,
          backgroundColor: const Color(0xFF1A1A1A),
          selectedItemColor: const Color(0xFFFFD700),
          unselectedItemColor: Colors.white30,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
          unselectedLabelStyle: const TextStyle(fontFamily: 'Cairo'),
          items: [
            const BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.house, size: 20),
              label: 'الرئيسية',
            ),
            const BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.utensils, size: 20),
              label: 'المنيو',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const FaIcon(FontAwesomeIcons.basketShopping, size: 20),
                  Consumer<CartProvider>(
                    builder: (context, cart, child) => cart.itemCount > 0
                        ? Positioned(
                            right: -8,
                            top: -8,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFD700),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 16,
                                minHeight: 16,
                              ),
                              child: Text(
                                '${cart.itemCount}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ),
                ],
              ),
              label: 'السلة',
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: const Color(0xFF121212),
        appBar: AppBar(
          backgroundColor: const Color(0xFF1A1A1A),
          elevation: 5,
          shadowColor: Colors.black45,
          title: Row(
            children: [
              const FaIcon(FontAwesomeIcons.utensils, color: Color(0xFFFFD700), size: 24),
              const SizedBox(width: 15),
              const Text(
                'SHAMIAT - شاميات',
                style: TextStyle(
                  color: Color(0xFFFFD700),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const Spacer(),
              _navButton('الرئيسية - HOME', 0),
              _navButton('القائمة - MENU', 1),
              const SizedBox(width: 20),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => onIndexChanged(2),
                    icon: const FaIcon(FontAwesomeIcons.basketShopping, size: 16),
                    label: const Text('السلة - CART'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: currentIndex == 2 ? const Color(0xFFFFD700) : Colors.white10,
                      foregroundColor: currentIndex == 2 ? Colors.black : Colors.white70,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  Consumer<CartProvider>(
                    builder: (context, cart, child) => cart.itemCount > 0
                        ? Positioned(
                            right: -5,
                            top: -5,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFD700),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.black, width: 1),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 20,
                                minHeight: 20,
                              ),
                              child: Text(
                                '${cart.itemCount}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: body,
      );
    }
  }

  Widget _navButton(String label, int index) {
    final isSelected = currentIndex == index;
    return TextButton(
      onPressed: () => onIndexChanged(index),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? const Color(0xFFFFD700) : Colors.white70,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 14,
        ),
      ),
    );
  }
}
