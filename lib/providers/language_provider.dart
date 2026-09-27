import 'package:flutter/material.dart';

class LanguageProvider with ChangeNotifier {
  bool _isArabic = true;

  bool get isArabic => _isArabic;

  void toggleLanguage() {
    _isArabic = !_isArabic;
    notifyListeners();
  }
}
