import 'package:dio/dio.dart';
import 'package:hp3ki/utils/constant.dart';
import 'package:hp3ki/views/screens/shop/data/models/shop.dart';
import 'package:hp3ki/views/screens/shop/data/models/shop_category.dart';

class ShopRepository {
  final Dio client;

  ShopRepository({required this.client});

  Future<ShopModel> getListProduct(int index, String category) async {
    try {
      final res = await client.get(
          "${AppConstants.baseUrl}/api/v1/product/list?page=$index&cat=$category");
      return ShopModel.fromJson(res.data["data"]);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ShopCategoryModel>> getCategories() async {
    try {
      final res =
          await client.get("${AppConstants.baseUrl}/api/v1/product/categories");

      return (res.data["data"] as List)
          .map((e) => ShopCategoryModel.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
