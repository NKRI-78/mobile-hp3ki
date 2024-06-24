import 'package:dio/dio.dart';
import 'package:hp3ki/utils/constant.dart';
import 'package:hp3ki/views/screens/tracking_order/data/jne_tracking_model.dart';

class TrackingOrderRepository {
  final Dio client;

  TrackingOrderRepository({required this.client});

  Future<JneTrackingModel> getTracking(String cnote) async {
    try {
      final res = await client
          .get("${AppConstants.baseUrl}/api/v1/order/$cnote/tracking");
      // print(res.data['data'].toString());
      return JneTrackingModel.fromJson(res.data['data']);
    } catch (e) {
      // print(e.toString());
      rethrow;
    }
  }
}
