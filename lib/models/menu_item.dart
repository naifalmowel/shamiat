class OptionChoice {
  final String nameAr;
  final String nameEn;
  final double price;

  OptionChoice({
    required this.nameAr,
    required this.nameEn,
    this.price = 0.0,
  });

  factory OptionChoice.fromMap(Map<String, dynamic> map) {
    return OptionChoice(
      nameAr: map['nameAr'] ?? map['name_ar'] ?? '',
      nameEn: map['nameEn'] ?? map['name_en'] ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nameAr': nameAr,
      'nameEn': nameEn,
      'price': price,
    };
  }
}

class MenuItemOptionGroup {
  final String titleAr;
  final String titleEn;
  final String type; // 'single' or 'multiple'
  final bool required;
  final List<OptionChoice> choices;

  MenuItemOptionGroup({
    required this.titleAr,
    required this.titleEn,
    this.type = 'single',
    this.required = false,
    required this.choices,
  });

  factory MenuItemOptionGroup.fromMap(Map<String, dynamic> map) {
    var rawChoices = map['choices'] as List? ?? [];
    List<OptionChoice> choicesList = rawChoices
        .map((c) => OptionChoice.fromMap(Map<String, dynamic>.from(c)))
        .toList();

    return MenuItemOptionGroup(
      titleAr: map['titleAr'] ?? map['title_ar'] ?? '',
      titleEn: map['titleEn'] ?? map['title_en'] ?? '',
      type: map['type'] ?? 'single',
      required: map['required'] ?? false,
      choices: choicesList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'titleAr': titleAr,
      'titleEn': titleEn,
      'type': type,
      'required': required,
      'choices': choices.map((c) => c.toMap()).toList(),
    };
  }
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
  final String category; 
  final bool isAvailable;
  final int order;
  final List<MenuItemOptionGroup> options;

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
    this.options = const [],
  });

  factory MenuItem.fromMap(Map<String, dynamic> map, String docId) {
    // Handling potential variation in field names from Dashboard
    String catId = map['category'] ?? map['categoryId'] ?? map['category_id'] ?? '';
    
    var rawOptions = map['options'] as List? ?? [];
    List<MenuItemOptionGroup> optionsList = rawOptions
        .map((o) => MenuItemOptionGroup.fromMap(Map<String, dynamic>.from(o)))
        .toList();

    return MenuItem(
      id: docId,
      nameAr: map['nameAr'] ?? map['name_ar'] ?? '',
      nameEn: map['nameEn'] ?? map['name_en'] ?? '',
      descriptionAr: map['descriptionAr'] ?? map['description_ar'] ?? '',
      descriptionEn: map['descriptionEn'] ?? map['description_en'] ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      discountPrice: (map['discountPrice'] as num?)?.toDouble() ?? (map['discount_price'] as num?)?.toDouble(),
      imageUrl: map['imageUrl'] ?? map['image_url'] ?? map['image'] ?? '',
      category: catId.trim(),
      isAvailable: map['isAvailable'] ?? map['is_available'] ?? true,
      order: map['order'] ?? 0,
      options: optionsList,
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
      'options': options.map((o) => o.toMap()).toList(),
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
      imageUrl: map['imageUrl'] ?? map['image_url'] ?? '',
      titleAr: map['titleAr'] ?? map['title_ar'] ?? '',
      titleEn: map['titleEn'] ?? map['title_en'] ?? '',
      subTitleAr: map['subTitleAr'] ?? map['sub_title_ar'] ?? '',
      subTitleEn: map['subTitleEn'] ?? map['sub_title_en'] ?? '',
      actionUrl: map['actionUrl'] ?? map['action_url'],
      isActive: map['isActive'] ?? map['is_active'] ?? true,
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
