import 'package:flutter/material.dart';

class LanguageProvider with ChangeNotifier {
  bool _isArabic = true;

  bool get isArabic => _isArabic;

  String get currentLanguage => _isArabic ? 'ar' : 'en';

  void toggleLanguage() {
    _isArabic = !_isArabic;
    notifyListeners();
  }

  void setLanguage(bool isAr) {
    _isArabic = isAr;
    notifyListeners();
  }
}
