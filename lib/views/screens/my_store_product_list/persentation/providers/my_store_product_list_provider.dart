import 'package:flutter/material.dart';
import 'package:hp3ki/views/screens/my_store_add_product/data/product_category_model.dart';
import 'package:hp3ki/views/screens/my_store_product_list/domain/my_store_product_list_repository.dart';
import 'package:hp3ki/views/screens/product/data/models/product_detail_model.dart';
import 'package:hp3ki/views/screens/product/data/models/product_model.dart';

class MyStoreProductListProvider with ChangeNotifier {
  final MyStoreProductListRepository repo;

  MyStoreProductListProvider({required this.repo});

  List<ProductModel> products = [];
  List<ProductCategoryModel> categories = [];
  int categoryIndex = 0;

  String get category => categoryIndex == 0 ? '' : categories[categoryIndex].id;

  String search = '';

  List<ProductModel> get filterProducts => products
      .where((e) => e.name.toLowerCase().contains(search.toLowerCase()))
      .toList();

  Future<ProductDetailModel> getDetail(String productId) async {
    try {
      return repo.getDetailProduct(productId);
    } catch (e) {
      rethrow;
    }
  }

  void init() {
    fetchCategories();
    fetchProducts();
  }

  void changeCategory(int index) {
    categoryIndex = index;
    fetchProducts();
    notifyListeners();
  }

  Future<void> fetchCategories() async {
    try {
      categories = await repo.getCategories();
      notifyListeners();
    } catch (e) {
      ///
    }
  }

  Future<void> fetchProducts() async {
    try {
      products = await repo.getProducts(
        categoryId: category,
      );
      notifyListeners();
    } catch (e) {
      ///
    }
  }

  void searchProduct(String value) {
    search = value;
    notifyListeners();
  }

  void deleteProduct(String id) async {
    try {
      await repo.deleteProduct(id);
      fetchProducts();
    } catch (e) {
      rethrow;
    }
  }
}
