import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../widgets/item_card.dart';
import '../providers/language_provider.dart';
import '../providers/menu_provider.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String? selectedCategoryId;
  final ScrollController _categoryScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final isAr = context.watch<LanguageProvider>().isArabic;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final menuProvider = context.watch<MenuProvider>();

    final dynamicCategories = menuProvider.categories;

    // Auto-select first category if none selected
    if (selectedCategoryId == null && dynamicCategories.isNotEmpty) {
      selectedCategoryId = dynamicCategories.first.id;
    }

    // Filter items from MenuProvider dynamically by String category ID
    final filteredItems = selectedCategoryId == null
        ? menuProvider.menuItems
        : menuProvider.menuItems
              .where((item) => item.category == selectedCategoryId)
              .toList();

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;
    final isNarrow = screenWidth < 380;

    return Column(
      children: [
        // Category Selector (Dynamic from Firebase)
        Container(
          height: 110,
          padding: const EdgeInsets.only(top: 10, bottom: 5),
          child: Column(
            children: [
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    dragDevices: {
                      PointerDeviceKind.touch,
                      PointerDeviceKind.mouse,
                    },
                  ),
                  child: ListView.builder(
                    controller: _categoryScrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: dynamicCategories.length,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    itemBuilder: (context, index) {
                      final cat = dynamicCategories[index];
                      final isSelected = selectedCategoryId == cat.id;
                      return GestureDetector(
                        onTap: () =>
                            setState(() => selectedCategoryId = cat.id),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.only(right: 12, bottom: 5),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? primaryColor
                                : (isDark
                                      ? Colors.white.withValues(alpha: 0.05)
                                      : Colors.white),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: primaryColor.withValues(
                                        alpha: 0.2,
                                      ),
                                      blurRadius: 6,
                                    ),
                                  ]
                                : [],
                            border: Border.all(
                              color: isSelected
                                  ? primaryColor
                                  : (isDark
                                        ? Colors.white10
                                        : Colors.black.withValues(alpha: 0.05)),
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  isAr ? cat.nameAr : cat.nameEn,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Theme.of(
                                            context,
                                          ).textTheme.bodyLarge?.color,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  isAr ? cat.nameEn : cat.nameAr,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white70
                                        : Colors.grey,
                                    fontSize: 9,
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
              Container(
                width: 40,
                height: 3,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child:
                    Center(
                          child: Container(
                            width: 15,
                            height: 3,
                            decoration: BoxDecoration(
                              color: primaryColor.withValues(alpha: 0.4),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        )
                        .animate(onPlay: (c) => c.repeat(reverse: true))
                        .moveX(begin: -10, end: 10, duration: 1.5.seconds),
              ),
            ],
          ),
        ),

        // Grid with dynamic items
        Expanded(
          child: filteredItems.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.no_meals_outlined,
                        size: 60,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        isAr
                            ? 'لا توجد منتجات في هذه الفئة حالياً'
                            : 'No items in this category yet',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.fromLTRB(15, 5, 15, 20),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isMobile ? 2 : (screenWidth > 1200 ? 4 : 3),
                    childAspectRatio: isNarrow ? 0.62 : 0.72,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
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
