import 'package:dio/dio.dart';
import 'package:hp3ki/utils/constant.dart';
import 'package:hp3ki/views/screens/my_store_order/data/order_model.dart';

class MyStoreOrderRepository {
  final Dio client;

  MyStoreOrderRepository({required this.client});

  Future<List<OrderModel>> getPendingOrder(String status) async {
    try {
      final res = await client.get(
        "${AppConstants.baseUrl}/api/v1/order/me?status=$status",
      );

      return (res.data['data'] as List)
          .map((e) => OrderModel.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> cancelOrder(String orderId, String msg) async {
    try {
      await client
          .post("${AppConstants.baseUrl}/api/v1/order/$orderId/cancel", data: {
        "reason": msg,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> confirmOrder(String orderId) async {
    try {
      await client.post(
        "${AppConstants.baseUrl}/api/v1/order/$orderId/confirm",
      );
    } catch (e) {
      rethrow;
    }
  }
}
