import 'menu_item.dart';

class MenuCategory {
  final String category; // Changed from Category enum to String
  final String nameAr;
  final String nameEn;
  final List<MenuItem> items;

  MenuCategory({
    required this.category,
    required this.nameAr,
    required this.nameEn,
    required this.items,
  });
}
