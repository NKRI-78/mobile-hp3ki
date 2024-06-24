import 'package:dio/dio.dart';
import 'package:hp3ki/utils/constant.dart';
import 'package:hp3ki/utils/dio.dart';
import 'package:hp3ki/views/screens/shop_cart/data/models/shop_cart.dart';

class ShopCartRepository {
  Dio client = DioManager.shared.getClient();

  Future<ShopCartModel> getCarts() async {
    try {
      final res = await client.get("${AppConstants.baseUrl}/api/v1/cart/info");

      return ShopCartModel.fromJson(res.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> cartSelected(String id,
      {String type = 'none', bool selected = false}) async {
    try {
      await client.post(
        "${AppConstants.baseUrl}/api/v1/cart/update/selected/$id",
        data: {"selected": selected, "type": type},
      );

      // return ShopCartModel.fromJson(res.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteCart(String id) async {
    try {
      await client.post("${AppConstants.baseUrl}/api/v1/cart/delete", data: {
        "cart_id": id,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> cartUpdateQty(String id, int qty) async {
    try {
      await client.post(
        "${AppConstants.baseUrl}/api/v1/cart/update/quantity",
        data: {
          "cart_id": id,
          "quantity": qty,
        },
      );
    } catch (e) {
      rethrow;
    }
  }
}
