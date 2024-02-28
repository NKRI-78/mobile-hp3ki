import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hp3ki/utils/constant.dart';
import 'package:hp3ki/views/screens/order_detail/data/order_detail_model.dart';

class OrderDetailRepository {
  final Dio client;

  OrderDetailRepository({required this.client});

  Future<String> uploadMedia(File image) async {
    try {
      final formData = FormData.fromMap({
        "folder": "reviews",
        "media": await MultipartFile.fromFile(
          image.path,
        ),
      });
      final resUpload = await client
          .post(AppConstants.baseUrl + '/api/v1/media', data: formData);

      return resUpload.data['data']['path'];
    } catch (e) {
      rethrow;
    }
  }

  Future<OrderDetailModel> getDetail(String orderId) async {
    try {
      final res = await client
          .get('${AppConstants.baseUrl}/api/v1/order/$orderId/detail');

      return OrderDetailModel.fromJson(res.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> submitReview(
      String orderId, Map<String, Map<String, dynamic>> reviews) async {
    try {
      await client
          .post('${AppConstants.baseUrl}/api/v1/order/$orderId/reviews', data: {
        "reviews": reviews,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> finishOrder(String orderId) async {
    try {
      await client.post('${AppConstants.baseUrl}/api/v1/order/$orderId/finish');
    } catch (e) {
      rethrow;
    }
  }
}
