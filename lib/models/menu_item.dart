class MenuItem {
  final String id;
  final String nameAr;
  final String nameEn;
  final String descriptionAr;
  final String descriptionEn;
  final double price;
  final double? discountPrice;
  final String imageUrl;
  final String category; 
  final bool isAvailable;
  final int order;

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
    this.order = 0,
  });

  factory MenuItem.fromMap(Map<String, dynamic> map, String docId) {
    return MenuItem(
      id: docId,
      nameAr: map['nameAr'] ?? '',
      nameEn: map['nameEn'] ?? '',
      descriptionAr: map['descriptionAr'] ?? '',
      descriptionEn: map['descriptionEn'] ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      discountPrice: (map['discountPrice'] as num?)?.toDouble(),
      imageUrl: map['imageUrl'] ?? '',
      category: map['category'] ?? '',
      isAvailable: map['isAvailable'] ?? true,
      order: map['order'] ?? 0,
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
      'category': category,
      'isAvailable': isAvailable,
      'order': order,
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
  final String? actionUrl;
  final bool isActive;
  final int order;

  CarouselItem({
    required this.id,
    required this.imageUrl,
    required this.titleAr,
    required this.titleEn,
    required this.subTitleAr,
    required this.subTitleEn,
    this.actionUrl,
    this.isActive = true,
    this.order = 0,
  });

  factory CarouselItem.fromMap(Map<String, dynamic> map, String docId) {
    return CarouselItem(
      id: docId,
      imageUrl: map['imageUrl'] ?? '',
      titleAr: map['titleAr'] ?? '',
      titleEn: map['titleEn'] ?? '',
      subTitleAr: map['subTitleAr'] ?? '',
      subTitleEn: map['subTitleEn'] ?? '',
      actionUrl: map['actionUrl'],
      isActive: map['isActive'] ?? true,
      order: map['order'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
      'titleAr': titleAr,
      'titleEn': titleEn,
      'subTitleAr': subTitleAr,
      'subTitleEn': subTitleEn,
      'actionUrl': actionUrl,
      'isActive': isActive,
      'order': order,
    };
  }
}
