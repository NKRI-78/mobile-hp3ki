import 'package:dio/dio.dart';
import 'package:hp3ki/utils/constant.dart';
import 'package:hp3ki/utils/dio.dart';
import 'package:hp3ki/views/screens/shipping_address/data/shipping_address_model.dart';

class ShippingAddressRepository {
  Dio client = DioManager.shared.getClient();

  ShippingAddressRepository();

  Future<List<ShippingAddressModel>> getAllShippingAddress() async {
    try {
      final res = await client
          .get("${AppConstants.baseUrl}/api/v1/shipping-address/list");
      return (res.data['data'] as List)
          .map((e) => ShippingAddressModel.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> setPrimaryAddress(String shippingAddressId) async {
    try {
      await client.get(
          "${AppConstants.baseUrl}/api/v1/shipping-address/select/$shippingAddressId");
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteShippingAddress(String shippingAddressId) async {
    try {
      await client.post(
          "${AppConstants.baseUrl}/api/v1/shipping-address/delete",
          data: {
            "shipping_address_id": shippingAddressId,
          });
    } catch (e) {
      rethrow;
    }
  }
}
