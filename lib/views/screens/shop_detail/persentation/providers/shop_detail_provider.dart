import 'package:flutter/material.dart';
import 'package:hp3ki/container.dart';
import 'package:hp3ki/views/screens/shop_cart/data/models/shop_cart.dart';
import 'package:hp3ki/views/screens/shop_cart/persentation/providers/shop_cart_provider.dart';
import 'package:hp3ki/views/screens/shop_detail/data/models/shop_detail.dart';
import 'package:hp3ki/views/screens/shop_detail/domain/shop_detail_repository.dart';

class ShopDetailProvider with ChangeNotifier {
  final ShopDetailRepository repo;
  final String id;

  PageController pageController = PageController();
  int indexPage = 0;

  ShopDetailModel? product;
  bool loading = true;
  bool loadingCart = false;
  String error = '';

  ShopDetailProvider({
    required this.repo,
    required this.id,
  });

  Future<void> fetchProductDetail() async {
    try {
      product = await repo.getProductDetail(id);
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  void onChangedPage(int index) {
    indexPage = index;
    notifyListeners();
  }

  void addToCart() async {
    try {
      loadingCart = true;
      notifyListeners();
      await repo.addToCart(id, product?.minOrder ?? 1, "");
      getIt<ShopCartProvider>().fetchCarts();
    } catch (e) {
      ///
    } finally {
      loadingCart = false;
      notifyListeners();
    }
  }

  Item? hasCart(ShopCartModel? cart) {
    final myCart =
        cart?.stores.where((store) => store.store.id == product?.store.id);

    if (myCart?.isNotEmpty ?? false) {
      final datas =
          myCart!.first.items.where((element) => element.id == id).toList();

      if (datas.isNotEmpty) {
        return datas.first;
      }
    }
    return null;
  }

  Future<void> addBuyNow() async {
    try {
      await repo.addBuyNow(
        productId: product?.id,
        quantity: 1,
        note: '-',
      );
    } catch (e) {
      rethrow;
    }
  }
}
