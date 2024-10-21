import 'package:flutter/material.dart';
import 'package:hp3ki/views/screens/shipping_address_add/shop/data/models/shop.dart';
import 'package:hp3ki/views/screens/shipping_address_add/shop/data/models/shop_category.dart';
import 'package:hp3ki/views/screens/shipping_address_add/shop/domain/shop_repository.dart';

import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class ShopProvider with ChangeNotifier {
  final ShopRepository repo;

  ShopProvider({required this.repo});

  int currentPage = 1;
  int nextPage = 1;
  int totalItem = 0;
  String category = '';

  ShopModel? shop;

  RefreshController refreshController = RefreshController();

  List<ShopCategoryModel> categories = [];

  void init() {
    fetchProductList();
    fetchCategory();
  }

  Future<void> fetchCategory() async {
    try {
      categories = await repo.getCategories();
      notifyListeners();
    } catch (e) {
      ///
    }
  }

  Future<void> fetchProductList({bool loadMore = false}) async {
    try {
      final page = loadMore ? nextPage : 1;
      final d = await repo.getListProduct(page, category);
      shop = loadMore
          ? shop?.copyWith(data: [
              ...shop?.data ?? [],
              ...d.data,
            ])
          : d;
      currentPage = d.currentPage;
      nextPage = d.nextPage;
      totalItem = d.total;
      notifyListeners();
    } catch (e) {
      ///
    } finally {
      refreshController.refreshCompleted();
      refreshController.loadComplete();
    }
  }

  void changeCategory(String type) {
    if (type == category) {
      category = '';
    } else {
      category = type;
    }
    notifyListeners();

    fetchProductList();
  }
}
