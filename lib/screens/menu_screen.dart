import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../data/menu_data.dart';
import '../models/menu_item.dart';
import '../widgets/item_card.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  Category? selectedCategory = Category.shawarma;

  @override
  Widget build(BuildContext context) {
    final filteredItems = selectedCategory == null
        ? menuCategories.expand((c) => c.items).toList()
        : menuCategories.firstWhere((c) => c.category == selectedCategory).items;

    final isMobile = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('القائمة - THE MENU'),
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.magnifyingGlass, size: 20),
            onPressed: () {},
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          // Elegant Category Selector
          Container(
            height: 90,
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: ListView.builder(
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
                    margin: const EdgeInsets.only(right: 15),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFFFD700) : Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: isSelected ? const Color(0xFFFFD700) : Colors.white10,
                      ),
                      boxShadow: isSelected ? [
                        BoxShadow(
                          color: const Color(0xFFFFD700).withOpacity(0.2),
                          blurRadius: 10,
                          spreadRadius: 2,
                        )
                      ] : [],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            cat.nameAr,
                            style: TextStyle(
                              color: isSelected ? Colors.black : Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            cat.nameEn,
                            style: TextStyle(
                              color: isSelected ? Colors.black87 : Colors.white54,
                              fontSize: 10,
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
          
          // Items Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD700),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  selectedCategory != null 
                    ? menuCategories.firstWhere((c) => c.category == selectedCategory).nameAr
                    : 'الكل',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                const FaIcon(FontAwesomeIcons.filter, size: 14, color: Colors.white54),
              ],
            ),
          ),
          
          // Items Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isMobile ? 2 : (MediaQuery.of(context).size.width > 1200 ? 4 : 3),
                childAspectRatio: 0.72,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                return ItemCard(item: filteredItems[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
