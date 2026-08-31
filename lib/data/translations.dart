class Translations {
  static const Map<String, Map<String, String>> _data = {
    'home': {'ar': 'الرئيسية', 'en': 'Home'},
    'menu': {'ar': 'القائمة', 'en': 'Menu'},
    'cart': {'ar': 'السلة', 'en': 'Cart'},
    'explore_menu': {'ar': 'اكتشف المنيو', 'en': 'Explore Menu'},
    'daily_offers': {'ar': 'عروض اليوم', 'en': 'Daily Offers'},
    'add_to_cart': {'ar': 'إضافة للسلة', 'en': 'Add to Cart'},
    'added_to_cart': {'ar': 'تمت الإضافة للسلة', 'en': 'Added to cart'},
    'subtotal': {'ar': 'الإجمالي الفرعي', 'en': 'Subtotal'},
    'total': {'ar': 'الإجمالي', 'en': 'Total'},
    'order_whatsapp': {'ar': 'تأكيد الطلب عبر واتساب', 'en': 'Order on WhatsApp'},
    'empty_cart': {'ar': 'السلة فارغة حالياً', 'en': 'Your cart is empty'},
    'start_ordering': {'ar': 'ابدأ بإضافة وجباتك المفضلة', 'en': 'Start adding your favorite meals'},
    'clear_all': {'ar': 'مسح الكل', 'en': 'Clear All'},
    'delivery_note': {
      'ar': 'ملاحظة: قد يتم إضافة رسوم توصيل إضافية حسب المنطقة',
      'en': 'Note: Additional delivery charges may apply based on the location'
    },
    'authentic_taste': {
      'ar': 'الذوق الشامي الأصيل في قلب رأس الخيمة',
      'en': 'Authentic Levantine Taste in the Heart of RAK'
    },
  };

  static String getText(String key, bool isArabic) {
    return _data[key]?[isArabic ? 'ar' : 'en'] ?? key;
  }
}
