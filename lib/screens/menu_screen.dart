import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../data/menu_data.dart';
import '../models/menu_item.dart';
import '../widgets/item_card.dart';
import '../providers/language_provider.dart';
import '../data/translations.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  Category? selectedCategory = Category.shawarma;
  final ScrollController _categoryScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final isAr = context.watch<LanguageProvider>().isArabic;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    final filteredItems = selectedCategory == null
        ? menuCategories.expand((c) => c.items).toList()
        : menuCategories.firstWhere((c) => c.category == selectedCategory).items;

    final isMobile = MediaQuery.of(context).size.width < 800;

    return Column(
      children: [
        // Improved Category Selector area
        Container(
          height: 120, // Increased height to prevent overflow
          padding: const EdgeInsets.only(top: 15, bottom: 5),
          child: Column(
            children: [
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
                  ),
                  child: ListView.builder(
                    controller: _categoryScrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: menuCategories.length,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemBuilder: (context, index) {
                      final cat = menuCategories[index];
                      final isSelected = selectedCategory == cat.category;
                      return GestureDetector(
                        onTap: () => setState(() => selectedCategory = cat.category),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.only(right: 15, bottom: 5),
                          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? primaryColor : (isDark ? Colors.white.withOpacity(0.05) : Colors.white),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: isSelected 
                              ? [BoxShadow(color: primaryColor.withOpacity(0.3), blurRadius: 8, spreadRadius: 1)]
                              : [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 5)],
                            border: Border.all(
                              color: isSelected ? primaryColor : (isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  isAr ? cat.nameAr : cat.nameEn,
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : Theme.of(context).textTheme.bodyLarge?.color,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  isAr ? cat.nameEn : cat.nameAr,
                                  style: TextStyle(
                                    color: isSelected ? Colors.white70 : Colors.grey,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 5),
              // Dynamic Scroll Indicator
              Container(
                width: 60,
                height: 3,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 20,
                      margin: const EdgeInsets.only(left: 20), // Placeholder logic for movement
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),
              ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 2.seconds),
            ],
          ),
        ),
        
        // Items Grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 2 : (MediaQuery.of(context).size.width > 1200 ? 4 : 3),
              childAspectRatio: 0.68,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            itemCount: filteredItems.length,
            itemBuilder: (context, index) {
              return ItemCard(item: filteredItems[index]);
            },
          ),
        ),
      ],
    );
  }
}
