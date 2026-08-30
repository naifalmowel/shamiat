enum Category {
  shawarma,
  burger,
  sandwich,
  meals,
  chicken,
  appetizers,
  drinks,
}

class MenuItem {
  final String id;
  final String nameAr;
  final String nameEn;
  final String descriptionAr;
  final String descriptionEn;
  final double price;
  final String imageUrl;
  final Category category;
  final List<String>? options;

  MenuItem({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    this.descriptionAr = '',
    this.descriptionEn = '',
    required this.price,
    required this.imageUrl,
    required this.category,
    this.options,
  });
}
