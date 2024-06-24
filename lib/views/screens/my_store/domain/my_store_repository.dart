import 'package:dio/dio.dart';
import 'package:hp3ki/utils/constant.dart';
import 'package:hp3ki/views/screens/my_store/data/my_store_model.dart';

class MyStoreRepository {
  final Dio client;

  MyStoreRepository({required this.client});

  Future<MyStoreModel> getDetailStore(String storeId) async {
    try {
      final res = await client.post(
          "${AppConstants.baseUrl}/api/v1/store/detail",
          data: {"id": storeId});

      return MyStoreModel.fromJson(res.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<int> getOrderPendingCount() async {
    try {
      final res = await client
          .get("${AppConstants.baseUrl}/api/v1/order/me/pending/count");

      return res.data['data']['order_count'];
    } catch (e) {
      rethrow;
    }
  }
}
