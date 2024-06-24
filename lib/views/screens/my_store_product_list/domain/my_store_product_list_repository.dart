import 'package:dio/dio.dart';
import 'package:hp3ki/utils/constant.dart';
import 'package:hp3ki/views/screens/my_store_add_product/data/product_category_model.dart';
import 'package:hp3ki/views/screens/product/data/models/product_detail_model.dart';
import 'package:hp3ki/views/screens/product/data/models/product_model.dart';

class MyStoreProductListRepository {
  final Dio client;

  MyStoreProductListRepository({required this.client});

  Future<List<ProductCategoryModel>> getCategories() async {
    try {
      final res =
          await client.get('${AppConstants.baseUrl}/api/v1/product/categories');

      return (res.data['data'] as List)
          .map((e) => ProductCategoryModel.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ProductModel>> getProducts(
      {int page = 1, String categoryId = ''}) async {
    try {
      final res = await client.get(
          '${AppConstants.baseUrl}/api/v1/product/seller/list?page=$page&categoryId=$categoryId');

      return (res.data['data'] as List)
          .map((e) => ProductModel.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<ProductDetailModel> getDetailProduct(productId) async {
    try {
      final res = await client
          .get('${AppConstants.baseUrl}/api/v1/product/info/$productId');

      return ProductDetailModel.fromJson(res.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      await client.post('${AppConstants.baseUrl}/api/v1/product/delete/$id');
    } catch (e) {
      rethrow;
    }
  }
}
