import 'package:flutter/material.dart';
import 'package:jungle/models/activity_model.dart';

class ActivityState with ChangeNotifier {
  List<Activity> _cartModel;
  int limit;
  bool modified;

  ActivityState(int limit) {
    _cartModel = new List<Activity>.empty(growable: true);
    this.limit = limit;
  }

  // Cart data list
  List<Activity> get getCart => _cartModel;
  bool get atLimit => _cartModel.length == limit;

  set(List<Activity> list) {
    print('set list');
    this._cartModel = list;
    modified = false;
    notifyListeners();
  }

  // Add item to cart
  bool addToCart(Activity value) {
    if (_cartModel.length >= limit) {
      return false;
    }
    _cartModel.add(value);
    modified = true;
    notifyListeners();
    return true;
  }

  // Remove item to cart
  removeFromCart(Activity value) {
    modified = true;
    _cartModel.remove(value);
    notifyListeners();
  }

  List<String> saveChanges() {
    modified = false;
    List<String> aids = [];
    _cartModel.forEach((element) {
      aids.add(element.aid);
    });
    return aids;
  }
}
