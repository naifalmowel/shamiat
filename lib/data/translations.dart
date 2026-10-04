class Translations {
  static const Map<String, Map<String, String>> _data = {
    'home': {'ar': 'الرئيسية', 'en': 'Home'},
    'menu': {'ar': 'القائمة', 'en': 'Menu'},
    'cart': {'ar': 'السلة', 'en': 'Cart'},
    'contact': {'ar': 'تواصل معنا', 'en': 'Contact'},
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
    'call_us': {'ar': 'الجوال', 'en': 'Mobile'},
    'landline': {'ar': 'الهاتف الأرضي', 'en': 'Landline Phone'},
    'whatsapp': {'ar': 'واتساب', 'en': 'WhatsApp'},
    'location': {'ar': 'موقعنا', 'en': 'Our Location'},
    'branch_info': {'ar': 'الفرع الرئيسي - رأس الخيمة', 'en': 'Main Branch - RAK'},
    'address': {
      'ar': 'رأس الخيمة - النخيل - شارع المنتصر - مقابل أبراج الدانة',
      'en': 'Ras Al Khaimah - Al Nakheel - Al Montasser Street - Opposite Al Dana Towers'
    },
    'social_media': {'ar': 'تابعنا على التواصل الاجتماعي', 'en': 'Follow us on Social Media'},
    'order_type': {'ar': 'نوع الطلب', 'en': 'Order Type'},
    'delivery': {'ar': 'توصيل منازل', 'en': 'Delivery'},
    'takeaway': {'ar': 'استلام من الفرع', 'en': 'Takeaway'},
    'full_name': {'ar': 'الاسم الكامل', 'en': 'Full Name'},
    'phone_number': {'ar': 'رقم الجوال', 'en': 'Phone Number'},
    'address_details': {'ar': 'العنوان التفصيلي (المنطقة، الشارع، البناية، الشقة)', 'en': 'Detailed Address (Area, Street, Building, Apt)'},
    'saved_addresses': {'ar': 'عناويني المحفوظة', 'en': 'Saved Addresses'},
    'add_new_address': {'ar': 'عنوان جديد', 'en': 'New Address'},
    'save_address_future': {'ar': 'حفظ العنوان للطلبات القادمة', 'en': 'Save address for future orders'},
    'get_location': {'ar': 'تحديد موقعي على الخريطة', 'en': 'Get My Map Location'},
    'confirm_and_send': {'ar': 'إرسال الطلب عبر الواتساب', 'en': 'Send Order on WhatsApp'},
    'please_fill_required': {'ar': 'يرجى إكمال جميع البيانات المطلوبة', 'en': 'Please fill in all required fields'},
  };

  static String getText(String key, bool isArabic) {
    return _data[key]?[isArabic ? 'ar' : 'en'] ?? key;
  }
}
