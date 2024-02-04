import 'dart:collection';
import 'package:flutter/material.dart';

class CartModel extends ChangeNotifier {
  /// Internal, private state of the cart.
  final List<int> _items = [];

  /// An unmodifiable view of the items in the cart.
  UnmodifiableListView<int> get items => UnmodifiableListView(_items);

  int getLength() {
    return items.length;
  }

  int getCartItem(index) {
    return _items[index];
  }

  List<int> getCart() {
    return _items;
  }

  void add(int item) {
    if (!isInCart(item)) {
      _items.add(item);

      notifyListeners();
    }
  }

  void remove(int item) {
    _items.removeWhere((element) => element == item);

    notifyListeners();
  }

  /// Removes all items from the cart.
  void removeAll() {
    _items.clear();

    notifyListeners();
  }

  bool isInCart(int index) {
    return _items.contains(index) ? true : false;
  }
}
