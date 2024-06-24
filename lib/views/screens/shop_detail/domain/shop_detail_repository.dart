import 'package:dio/dio.dart';
import 'package:hp3ki/utils/constant.dart';
import 'package:hp3ki/views/screens/shop_detail/data/models/shop_detail.dart';

class ShopDetailRepository {
  final Dio client;

  ShopDetailRepository({required this.client});

  Future<ShopDetailModel> getProductDetail(String id) async {
    try {
      final res =
          await client.get("${AppConstants.baseUrl}/api/v1/product/info/$id");
      return ShopDetailModel.fromJson(res.data["data"]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addToCart(String id, int qty, String note) async {
    try {
      await client.post("${AppConstants.baseUrl}/api/v1/cart/add",
          data: {"product_id": id, "quantity": qty, "note": note});
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addBuyNow(
      {String? productId, required int quantity, required String note}) async {
    try {
      await client.post(
        "${AppConstants.baseUrl}/api/v1/checkout/product/add/buy-now",
        data: {"product_id": productId, "quantity": quantity, "note": note},
      );
    } catch (e) {
      rethrow;
    }
  }
}
