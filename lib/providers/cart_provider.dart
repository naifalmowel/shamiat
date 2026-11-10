import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/menu_item.dart';

class CartItem {
  final MenuItem item;
  int quantity;
  final List<OptionChoice> selectedChoices;

  CartItem({
    required this.item,
    this.quantity = 1,
    this.selectedChoices = const [],
  });

  double get optionsExtraPrice {
    return selectedChoices.fold(0.0, (sum, choice) => sum + choice.price);
  }

  double get activeUnitPrice {
    double p = item.price;
    double d = item.discountPrice ?? 0;
    double base = (d > 0) ? (d < p ? d : p) : p;
    return base + optionsExtraPrice;
  }

  double get originalUnitPrice {
    double p = item.price;
    double d = item.discountPrice ?? 0;
    double base = (d > 0) ? (d > p ? d : p) : p;
    return base + optionsExtraPrice;
  }

  Map<String, dynamic> toMap() {
    return {
      'item': item.toMap(),
      'itemId': item.id,
      'quantity': quantity,
      'selectedChoices': selectedChoices.map((c) => c.toMap()).toList(),
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      item: MenuItem.fromMap(map['item'] ?? {}, map['itemId'] ?? ''),
      quantity: map['quantity'] ?? 1,
      selectedChoices: (map['selectedChoices'] as List? ?? [])
          .map((c) => OptionChoice.fromMap(Map<String, dynamic>.from(c)))
          .toList(),
    );
  }

  String toJson() => json.encode(toMap());

  factory CartItem.fromJson(String source) => CartItem.fromMap(json.decode(source));
}

class CartProvider with ChangeNotifier {
  static const String _cartPrefKey = 'shamiat_saved_cart_v1';
  final Map<String, CartItem> _items = {};

  CartProvider() {
    _loadCartFromPrefs();
  }

  Map<String, CartItem> get items => {..._items};

  int get itemCount => _items.length;

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.activeUnitPrice * cartItem.quantity;
    });
    return total;
  }

  double get totalOriginalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.originalUnitPrice * cartItem.quantity;
    });
    return total;
  }

  String _generateCartKey(String itemId, List<OptionChoice> choices) {
    if (choices.isEmpty) return itemId;
    final choiceKeys = choices.map((c) => '${c.nameAr}_${c.price}').toList()..sort();
    return '${itemId}_${choiceKeys.join('_')}';
  }

  void _saveCartToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      Map<String, String> rawMap = {};
      _items.forEach((key, cartItem) {
        rawMap[key] = cartItem.toJson();
      });
      await prefs.setString(_cartPrefKey, json.encode(rawMap));
    } catch (e) {
      // ignore
    }
  }

  void _loadCartFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? jsonString = prefs.getString(_cartPrefKey);
      if (jsonString != null && jsonString.isNotEmpty) {
        Map<String, dynamic> rawMap = json.decode(jsonString);
        _items.clear();
        rawMap.forEach((key, value) {
          _items[key] = CartItem.fromJson(value);
        });
        notifyListeners();
      }
    } catch (e) {
      // ignore
    }
  }

  void addItem(MenuItem item, {List<OptionChoice> selectedChoices = const []}) {
    final String key = _generateCartKey(item.id, selectedChoices);

    if (_items.containsKey(key)) {
      _items.update(
        key,
        (existing) => CartItem(
          item: existing.item,
          quantity: existing.quantity + 1,
          selectedChoices: existing.selectedChoices,
        ),
      );
    } else {
      _items.putIfAbsent(
        key,
        () => CartItem(
          item: item,
          selectedChoices: List.from(selectedChoices),
        ),
      );
    }
    _saveCartToPrefs();
    notifyListeners();
  }

  void removeItem(String key) {
    _items.remove(key);
    _saveCartToPrefs();
    notifyListeners();
  }

  void removeSingleItem(String keyOrItemId) {
    if (_items.containsKey(keyOrItemId)) {
      if (_items[keyOrItemId]!.quantity > 1) {
        _items[keyOrItemId]!.quantity--;
      } else {
        _items.remove(keyOrItemId);
      }
      _saveCartToPrefs();
      notifyListeners();
      return;
    }

    // Fallback: search for items matching item.id
    final matchingKeys = _items.entries.where((e) => e.value.item.id == keyOrItemId).map((e) => e.key).toList();
    if (matchingKeys.isNotEmpty) {
      final keyToRemove = matchingKeys.last;
      if (_items[keyToRemove]!.quantity > 1) {
        _items[keyToRemove]!.quantity--;
      } else {
        _items.remove(keyToRemove);
      }
      _saveCartToPrefs();
      notifyListeners();
    }
  }

  int getQuantity(String itemId) {
    int count = 0;
    _items.forEach((key, cartItem) {
      if (cartItem.item.id == itemId) {
        count += cartItem.quantity;
      }
    });
    return count;
  }

  void clearCart() {
    _items.clear();
    _saveCartToPrefs();
    notifyListeners();
  }
}
