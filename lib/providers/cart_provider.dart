import 'package:flutter/material.dart';
import '../models/menu_item.dart';

class CartItem {
  final MenuItem item;
  int quantity;

  CartItem({required this.item, this.quantity = 1});
}

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get itemCount => _items.length;

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.item.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(MenuItem item) {
    if (_items.containsKey(item.id)) {
      _items.update(
        item.id,
        (existing) => CartItem(
          item: existing.item,
          quantity: existing.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        item.id,
        () => CartItem(item: item),
      );
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void removeSingleItem(String id) {
    if (!_items.containsKey(id)) return;
    if (_items[id]!.quantity > 1) {
      _items.update(
        id,
        (existing) => CartItem(
          item: existing.item,
          quantity: existing.quantity - 1,
        ),
      );
    } else {
      _items.remove(id);
    }
    notifyListeners();
  }

  int getQuantity(String id) {
    return _items[id]?.quantity ?? 0;
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
