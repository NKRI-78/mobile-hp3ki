import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hp3ki/utils/constant.dart';
import 'package:hp3ki/views/screens/my_store_add_product/data/product_category_model.dart';
import 'package:hp3ki/views/screens/my_store_add_product/data/product_condition_model.dart';

class MyStoreAddProductRepository {
  final Dio client;

  MyStoreAddProductRepository({required this.client});

  Future<String> uploadMedia(File image) async {
    try {
      final formData = FormData.fromMap({
        "folder": "store-products",
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

  Future<void> addProductImageBulk(String id, List<String> paths) async {
    try {
      await client.post(
        '${AppConstants.baseUrl}/api/v1/product/upload-media-bulk',
        data: {
          "product_id": id,
          "paths": paths,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteProductImageAll(String id) async {
    try {
      await client.post(
        '${AppConstants.baseUrl}/api/v1/product/delete-media-all',
        data: {
          "product_id": id,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addProduct(
      {required String name,
      required String description,
      required String categoryId,
      required String conditionId,
      required int price,
      required int weight,
      required int stock,
      required String id,
      required bool open,
      required int minOrder}) async {
    try {
      var data = json.encode({
        "uid": id,
        "name": name,
        "price": price,
        "weight": weight,
        "description": description,
        "stock": stock,
        "category_id": categoryId,
        "condition": conditionId,
        "min_order": minOrder,
        "open": open ? "1" : "0"
      });

      await client.post("${AppConstants.baseUrl}/api/v1/product", data: data);
    } catch (e) {
      rethrow;
    }
  }

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

  Future<List<ProductConditionModel>> getConditions() async {
    try {
      final res =
          await client.get('${AppConstants.baseUrl}/api/v1/product/conditions');

      return (res.data['data'] as List)
          .map((e) => ProductConditionModel.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
