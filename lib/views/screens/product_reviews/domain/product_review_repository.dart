import 'package:dio/dio.dart';
import 'package:hp3ki/utils/constant.dart';
import 'package:hp3ki/views/screens/product_reviews/data/product_review.dart';

class ProductReviewRepository {
  final Dio client;

  ProductReviewRepository({required this.client});

  Future<List<ProductReviewModel>> fetchReview(String productId) async {
    try {
      final res = await client.get(
          '${AppConstants.baseUrl}/api/v1/product/detail/review/$productId');
      return (res.data['data'] as List)
          .map((e) => ProductReviewModel.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
