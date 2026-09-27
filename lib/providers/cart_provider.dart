import 'package:flutter/material.dart';
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
}

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

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
    notifyListeners();
  }

  void removeItem(String key) {
    _items.remove(key);
    notifyListeners();
  }

  void removeSingleItem(String keyOrItemId) {
    if (_items.containsKey(keyOrItemId)) {
      if (_items[keyOrItemId]!.quantity > 1) {
        _items[keyOrItemId]!.quantity--;
      } else {
        _items.remove(keyOrItemId);
      }
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
    notifyListeners();
  }
}
