import 'package:dio/dio.dart';
import 'package:hp3ki/utils/constant.dart';
import 'package:hp3ki/views/screens/payment_method/data/payment_method_model.dart';
import 'package:hp3ki/views/screens/product/data/models/product_checkout_model.dart';
import 'package:hp3ki/views/screens/shop_checkout/data/checkout_response_model.dart';
import 'package:hp3ki/views/screens/shop_checkout/data/raja_ongkir_cost_model.dart';

class ShopCheckoutRepository {
  final Dio client;

  ShopCheckoutRepository({required this.client});

  Future<ProductCheckoutModel> fetchProductFromCart() async {
    try {
      final res = await client.get("${AppConstants.baseUrl}/api/v1/cart/info");
      return ProductCheckoutModel.fromJson(res.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<ProductCheckoutModel> fetchProductLive() async {
    try {
      final res = await client
          .get("${AppConstants.baseUrl}/api/v1/checkout/product-live/info");
      return ProductCheckoutModel.fromJson(res.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<RajaOngkirCostModel> fetchCost({
    required String storeId,
    String buyfrom = 'cart',
  }) async {
    try {
      final res = await client.post(
        "${AppConstants.baseUrl}/api/v1/checkout/courier-cost-list",
        data: {
          "store_id": storeId,
          "buy_from": buyfrom,
        },
      );
      return RajaOngkirCostModel.fromJson(res.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<CheckoutResponseModel> checkout({
    required Map<String, RoService> delivery,
    required PaymentMethodModel paymentMethod,
    required String buyFrom,
  }) async {
    try {
      final mapDelivery =
          delivery.map((key, value) => MapEntry(key, value.toJson()));

      final res = await client.post(
        "${AppConstants.baseUrl}/api/v1/checkout/",
        data: {
          "shipment": mapDelivery,
          "payment_method": paymentMethod.toJson(),
          "buy_from": buyFrom,
        },
      );

      return CheckoutResponseModel.fromJson(res.data["data"]);
    } catch (e) {
      rethrow;
    }
  }
}
