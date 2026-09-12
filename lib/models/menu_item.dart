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
  final double? discountPrice;
  final String imageUrl;
  final Category category;
  final bool isAvailable;
  final List<String>? options;

  MenuItem({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    this.descriptionAr = '',
    this.descriptionEn = '',
    required this.price,
    this.discountPrice,
    required this.imageUrl,
    required this.category,
    this.isAvailable = true,
    this.options,
  });

  factory MenuItem.fromMap(Map<String, dynamic> map, String docId) {
    Category cat = Category.shawarma;
    for (var val in Category.values) {
      if (val.name == map['category']) {
        cat = val;
        break;
      }
    }

    return MenuItem(
      id: docId,
      nameAr: map['nameAr'] ?? '',
      nameEn: map['nameEn'] ?? '',
      descriptionAr: map['descriptionAr'] ?? '',
      descriptionEn: map['descriptionEn'] ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      discountPrice: (map['discountPrice'] as num?)?.toDouble(),
      imageUrl: map['imageUrl'] ?? '',
      category: cat,
      isAvailable: map['isAvailable'] ?? true,
      options: map['options'] != null ? List<String>.from(map['options']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nameAr': nameAr,
      'nameEn': nameEn,
      'descriptionAr': descriptionAr,
      'descriptionEn': descriptionEn,
      'price': price,
      'discountPrice': discountPrice,
      'imageUrl': imageUrl,
      'category': category.name,
      'isAvailable': isAvailable,
      'options': options,
    };
  }
}

class CarouselItem {
  final String id;
  final String imageUrl;
  final String titleAr;
  final String titleEn;
  final String subTitleAr;
  final String subTitleEn;

  CarouselItem({
    required this.id,
    required this.imageUrl,
    required this.titleAr,
    required this.titleEn,
    required this.subTitleAr,
    required this.subTitleEn,
  });

  factory CarouselItem.fromMap(Map<String, dynamic> map, String docId) {
    return CarouselItem(
      id: docId,
      imageUrl: map['imageUrl'] ?? '',
      titleAr: map['titleAr'] ?? '',
      titleEn: map['titleEn'] ?? '',
      subTitleAr: map['subTitleAr'] ?? '',
      subTitleEn: map['subTitleEn'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
      'titleAr': titleAr,
      'titleEn': titleEn,
      'subTitleAr': subTitleAr,
      'subTitleEn': subTitleEn,
    };
  }
}
