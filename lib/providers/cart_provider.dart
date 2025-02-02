import 'package:flutter/foundation.dart';

import '../models/models.dart';

class CartItem {
  final Item item;
  int count;

  CartItem({required this.item, required this.count});
}

class CartProvider with ChangeNotifier {
  List<Map<String, dynamic>> _items = [];
  String _orderType = '';

  List<Map<String, dynamic>> get items => _items;

  //! yha pe Item ko use krra me jo fetch krte samay use krta hu
  // Order ke liye change krna hoga

  // double get totalPrice => _items.fold(
  //     0, (total, item) => total + (item['price'] * item['quantity']));

  String get orderType => _orderType;

  /// Adds an item to the cart or updates quantity if it already exists
  void addItem(Map<String, dynamic> newItem) {
    int index =
        _items.indexWhere((item) => item['foodname'] == newItem['foodname']);
    if (index != -1) {
      _items[index]['quantity'] += newItem['quantity'];
    } else {
      _items.add({...newItem, 'quantity': newItem['quantity']});
    }

    print("added item: $newItem");
    print(_items);
    notifyListeners();
  }

  /// Sets the order type (e.g., Dine-in, Takeaway, Delivery)
  void setOrderType(String type) {
    _orderType = type;
    notifyListeners();
  }

  /// Clears all items from the cart
  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  /// Removes a specific item by its foodname
  void removeItem(String foodname) {
    _items.removeWhere((item) => item['foodname'] == foodname);
    notifyListeners();
  }

  /// Decreases the quantity of a specific item by its foodname
  void decreaseItemQuantity(String foodname) {
    int index = _items.indexWhere((item) => item['foodname'] == foodname);
    if (index != -1 && _items[index]['quantity'] > 1) {
      _items[index]['quantity'] -= 1;
    } else {
      _items.removeWhere((item) => item['foodname'] == foodname);
    }
    notifyListeners();
  }

  /// Gets the count of a specific item in the cart by foodname
  int getItemCount(String foodname) {
    return _items.firstWhere((item) => item['foodname'] == foodname,
        orElse: () => {'quantity': 0})['quantity'];
  }

  int get itemCount =>
      _items.fold(0, (sum, item) => sum + (item['quantity'] as int));

  double get totalPrice => _items.fold(
      0,
      (total, item) =>
          total +
          (double.tryParse(item['price'].toString()) ?? 0) * item['quantity']);
}
