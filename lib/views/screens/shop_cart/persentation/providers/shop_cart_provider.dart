import 'package:flutter/material.dart';
import 'package:hp3ki/views/screens/shop_cart/data/models/shop_cart.dart';
import 'package:hp3ki/views/screens/shop_cart/domain/shop_cart_repository.dart';

class ShopCartProvider with ChangeNotifier {
  final ShopCartRepository repo;

  ShopCartProvider({required this.repo});

  ShopCartModel? carts;
  bool loading = true;
  String error = "";

  int get total => carts?.totalItem ?? 0;

  Future<void> fetchCarts() async {
    try {
      carts = await repo.getCarts();
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  void deleteItem(String id) async {
    try {
      await repo.deleteCart(id);
      fetchCarts();
    } catch (e) {
      ///
    }
  }

  void updateQuantity(String id, int qty) async {
    try {
      await repo.cartUpdateQty(id, qty);
      fetchCarts();
    } catch (e) {
      ///
    }
  }
}
