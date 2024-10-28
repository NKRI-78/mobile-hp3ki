import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:hp3ki/data/models/ecommerce/balance/balance.dart';

import 'package:hp3ki/data/models/ecommerce/checkout/list.dart';
import 'package:hp3ki/data/models/ecommerce/courier/courier.dart';
import 'package:hp3ki/data/models/ecommerce/order/detail.dart';
import 'package:hp3ki/data/models/ecommerce/order/list.dart';
import 'package:hp3ki/data/models/ecommerce/order/tracking.dart';
import 'package:hp3ki/data/models/ecommerce/payment/how_to.dart';
import 'package:hp3ki/data/models/ecommerce/payment/payment.dart';
import 'package:hp3ki/data/models/ecommerce/payment/response_emoney.dart';
import 'package:hp3ki/data/models/ecommerce/payment/response_va.dart';
import 'package:hp3ki/data/models/ecommerce/product/category.dart';
import 'package:hp3ki/data/models/ecommerce/product/transaction.dart';
import 'package:hp3ki/data/models/ecommerce/region/subdistrict.dart';
import 'package:hp3ki/data/models/ecommerce/shipping_address/shipping_address_default.dart';
import 'package:hp3ki/data/models/ecommerce/shipping_address/shipping_address_detail.dart';
import 'package:hp3ki/data/models/ecommerce/region/district.dart';
import 'package:hp3ki/data/models/ecommerce/region/city.dart';
import 'package:hp3ki/data/models/ecommerce/region/province.dart';
import 'package:hp3ki/data/models/ecommerce/shipping_address/shipping_address.dart';
import 'package:hp3ki/data/models/ecommerce/cart/cart.dart';
import 'package:hp3ki/data/models/ecommerce/product/all.dart';
import 'package:hp3ki/data/models/ecommerce/product/detail.dart';
import 'package:hp3ki/data/models/ecommerce/store/owner.dart';
import 'package:hp3ki/data/models/ecommerce/store/store.dart';
import 'package:hp3ki/utils/shared_preferences.dart';

import 'package:hp3ki/views/basewidgets/snackbar/snackbar.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/dio.dart';

class EcommerceRepo {
  final SharedPreferences sp;
  
  EcommerceRepo({
    required this.sp
  });

  Future<BalanceModel> getBalance() async {
    try {
      Dio dio = DioManager.shared.getClient();
      Response response = await dio.post("https://api-ecommerce-general.inovatiftujuh8.com/ecommerces/v1/user/balance",
        data: {
          "user_id": SharedPrefs.getUserId()
        }
      );
      Map<String, dynamic> data = response.data;
      BalanceModel balanceModel = BalanceModel.fromJson(data);
      return balanceModel;
    } catch(e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      throw Exception('Failed to get balance');
    }
  }

  Future<void> createProductImage({
    required String productId,
    required String path
  }) async {
    try {
      Dio dio = DioManager.shared.getClient();
      await dio.post("https://api-ecommerce-general.inovatiftujuh8.com/ecommerces/v1/products/store/image",
        data: {
          "product_id": productId,
          "path": path
        }
      );
    } on DioError catch(e) {
      debugPrint(e.response!.data.toString());
      throw Exception("Failed create product image");
    } catch(e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      throw Exception("Failed create product image");
    }
  }

  Future<void> createProduct({
    required String id,
    required String title,
    required String description,
    required int price,
    required int weight,
    required int stock,
    required bool isDraft,
    required String catId,
    required String storeId
  }) async {
    try {
      Dio dio = DioManager.shared.getClient();
      await dio.post("https://api-ecommerce-general.inovatiftujuh8.com/ecommerces/v1/products/store",
        data: {
          "id": id,
          "title": title,
          "description": description,
          "price": price,
          "weight": weight,
          "stock": stock,
          "is_draft": isDraft,
          "cat_id": catId,
          "store_id": storeId,
          "app_name": "hp3ki"
        }
      );
    } on DioError catch(e) {
      debugPrint(e.response!.data.toString());
      throw Exception("Failed create product");
    } catch(e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      throw Exception('Failed create product');
    }
  }

  Future<void> updateProduct({
    required String id,
    required String title,
    required String description,
    required int price,
    required int weight,
    required int stock,
    required bool isDraft,
    required String catId
  }) async {
    try {
      Dio dio = DioManager.shared.getClient();
      await dio.put("https://api-ecommerce-general.inovatiftujuh8.com/ecommerces/v1/products/update/$id",
        data: {
          "title": title,
          "description": description,
          "price": price,
          "weight": weight,
          "stock": stock,
          "is_draft": isDraft,
          "cat_id": catId,
        }
      );
    } on DioError catch(e) {
      debugPrint(e.response!.data.toString());
      throw Exception("Failed update product");
    } catch(e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      throw Exception("Failed update product");
    }
  }

  Future<ProductModel> fetchAllProduct({
    required String search, 
    required String cat,
    required int page
  }) async {
    try {
      Dio dio = DioManager.shared.getClient();
      Response response = await dio.get("https://api-ecommerce-general.inovatiftujuh8.com/ecommerces/v1/products/all?page=$page&limit=5&search=$search&app_name=hp3ki&cat=$cat");
      Map<String, dynamic> data = response.data;
      ProductModel productModel = ProductModel.fromJson(data);
      return productModel;
    } catch(e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      throw Exception('Failed to load products');
    }
  }

  Future<ProductModel> fetchAllProductSeller({
    required String search, 
    required String cat,
    required String storeId,
    required int page,
  }) async {
    try {
      Dio dio = DioManager.shared.getClient();
      Response response = await dio.get("https://api-ecommerce-general.inovatiftujuh8.com/ecommerces/v1/products/seller/all?page=$page&limit=5&search=$search&app_name=hp3ki&store_id=$storeId&cat=$cat");
      Map<String, dynamic> data = response.data;
      ProductModel productModel = ProductModel.fromJson(data);
      return productModel;
    } catch(e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      throw Exception('Failed to load products');
    }
  }

  Future<ProductCategoryModel> fetchProductCategory() async {
    try {
      Dio dio = DioManager.shared.getClient();
      Response response = await dio.get("https://api-ecommerce-general.inovatiftujuh8.com/ecommerces/v1/products/category?app_name=hp3ki");
      Map<String, dynamic> data = response.data;
      ProductCategoryModel productCategoryModel = ProductCategoryModel.fromJson(data);
      return productCategoryModel;
    } catch(e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      throw Exception('Failed to load product categories');
    }
  }

  Future<ProductTransactionModel> fetchProductTransaction({
    required String transactionId
  }) async {
    try {
      Dio dio = DioManager.shared.getClient();
      Response response = await dio.get("https://api-ecommerce-general.inovatiftujuh8.com/ecommerces/v1/products/transaction/$transactionId");
      Map<String, dynamic> data = response.data;
      ProductTransactionModel productTransactionModel = ProductTransactionModel.fromJson(data);
      return productTransactionModel;
    } catch(e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      throw Exception('Failed to load product transaction');
    }
  }

  Future<ProductDetailModel> getProduct({required String productId}) async {
    try {   
      Dio dio = DioManager.shared.getClient();
      Response response = await dio.get("https://api-ecommerce-general.inovatiftujuh8.com/ecommerces/v1/products/detail/$productId");
      Map<String, dynamic> data = response.data;
      ProductDetailModel productDetailModel = ProductDetailModel.fromJson(data);
      return productDetailModel;
    } catch(e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      throw Exception("Failed to load product");
    }
  }

  Future<void> productReview({
    required String caption,
    required String productId,
    required String transactionId,
    required double rating
  }) async {
    try {
      Dio dio = DioManager.shared.getClient();
      await dio.post("https://api-ecommerce-general.inovatiftujuh8.com/ecommerces/v1/products/review",
        data: {
          "caption": caption,
          "product_id": productId, 
          "transaction_id": transactionId,
          "rate": rating,
          "user_id": SharedPrefs.getUserId()
        }
      );
    } catch(e) {
      debugPrint(e.toString());
      throw Exception("Failed to add product review");
    }
  }

  Future<void> productReviewMedia({
    required String productId,
    required String path,
  }) async {
    try {
      Dio dio = DioManager.shared.getClient();
      await dio.post("https://api-ecommerce-general.inovatiftujuh8.com/ecommerces/v1/products/review/media", 
        data: {
          "product_id": productId,
          "path": path
        }
      );
    } catch(e) {
      debugPrint(e.toString()); 
      throw Exception("Failed to product review media");
    }
  }

  Future<void> cancelOrder({required String transactionId}) async {
    try {
      Dio dio = DioManager.shared.getClient();
      await dio.post("https://api-ecommerce-general.inovatiftujuh8.com/ecommerces/v1/order/cancel",
        data: {
          "transaction_id": transactionId,
          "app": "hp3ki"
        }
      );
    } on DioError catch(e) {
      debugPrint(e.response!.data.toString());
      throw Exception("Failed to cancel order");
    } catch(e) {
      debugPrint(e.toString());
      throw Exception("Failed to cancel order");
    }
  }

  Future<ListOrderModel> getOrderList({required String orderStatus}) async {
    try { 
      Dio dio = DioManager.shared.getClient();
      Response response = await dio.post("https://api-ecommerce-general.inovatiftujuh8.com/ecommerces/v1/order/list",
        data: {
          "app": "hp3ki",
          "order_status": orderStatus,
          "user_id": SharedPrefs.getUserId()
        }
      );
      Map<String, dynamic> data = response.data;
      ListOrderModel listOrderModel = ListOrderModel.fromJson(data);
      return listOrderModel;
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw Exception("Failed to order list");
    }
  }

  Future<DetailOrderModel> getOrderDetail({required String transactionId}) async {
    try {
      Dio dio = DioManager.shared.getClient();
      Response response = await dio.post("https://api-ecommerce-general.inovatiftujuh8.com/ecommerces/v1/order/detail",
        data: {
          "transaction_id": transactionId, 
          "app": "hp3ki"
        }
      );
      Map<String, dynamic> data = response.data;
      DetailOrderModel detailOrderModel = DetailOrderModel.fromJson(data);
      return detailOrderModel;
    } on DioError catch(e) {
      debugPrint(e.response!.data.toString());
      throw Exception("Failed to order detail");
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      debugPrint(e.toString());
      throw Exception("Failed to order detail");
    }
  }

  Future<TrackingModel> getTracking({required String waybill}) async {
    try {
      Dio dio = DioManager.shared.getClient();
      Response response = await dio.post("https://api-ecommerce-general.inovatiftujuh8.com/ecommerces/v1/order/tracking",
        data: {
          "waybill": waybill
        }
      );
      Map<String, dynamic> data = response.data;
      TrackingModel trackingModel = TrackingModel.fromJson(data);
      return trackingModel;
    } catch(e) {
      debugPrint(e.toString());
      throw Exception("Failed to get tracking");
    }
  }

  Future<CartModel> getCart() async {
    try {
      Dio dio = DioManager.shared.getClient();
      Response response = await dio.post("https://api-ecommerce-general.inovatiftujuh8.com/ecommerces/v1/carts",
        data: {
          "user_id": SharedPrefs.getUserId()
        }
      );
      Map<String, dynamic> data = response.data;
      CartModel cartModel = CartModel.fromJson(data);
      return cartModel;
    } catch(e) {
      debugPrint(e.toString());
      throw Exception('Failed to get cart');
    }
  }

  Future<String> addToCart({
    required String productId,
    required int qty,
    required String note
  }) async {
    try {
      var dataObj = {
        "user_id": SharedPrefs.getUserId(),
        "product_id": productId,
        "qty": qty,
        "note": note
      };
      Dio dio = DioManager.shared.getClient();
      Response response = await dio.post("https://api-ecommerce-general.inovatiftujuh8.com/ecommerces/v1/carts/store",
        data: dataObj
      );
      Map<String, dynamic> data = response.data;
      return data["data"]["cart_id"];
    } on DioError catch(e) {
      ShowSnackbar.snackbar(e.response!.data["message"], "", ColorResources.error);
      debugPrint(e.response!.data.toString());
    } catch(e) {
      debugPrint(e.toString());
      throw Exception('Failed to add to cart');
    }
    return "";
  }

  Future<String> addToCartLive({
    required String productId,
    required String note
  }) async {
    try {
      var dataObj = {
        "user_id": SharedPrefs.getUserId(),
        "product_id": productId,
        "note": note
      };
      Dio dio = DioManager.shared.getClient();
      Response response = await dio.post("https://api-ecommerce-general.inovatiftujuh8.com/ecommerces/v1/carts/live/store",
        data: dataObj
      );
      Map<String, dynamic> data = response.data;
      return data["data"]["cart_id"];
    } on DioError catch(e) {
      ShowSnackbar.snackbar(e.response!.data["message"], "", ColorResources.error);
      debugPrint(e.response!.data.toString());
    } catch(e) {
      debugPrint(e.toString());
      throw Exception('Failed to add to cart');
    }
    return "";
  }

  Future<void> deleteCart({required String cartId}) async {
    try {     
      Dio dio = DioManager.shared.getClient();
      await dio.delete("https://api-ecommerce-general.inovatiftujuh8.com/ecommerces/v1/carts/delete",
        data: {
          "user_id": SharedPrefs.getUserId(),
          "cart_id": cartId
        }
      );
    } catch(e) {
      debugPrint(e.toString());
      throw Exception('Failed to delete cart');
    }
  } 

  Future<void> deleteCartAll() async {
    try {
      Dio dio = DioManager.shared.getClient();
      await dio.delete("https://api-ecommerce-general.inovatiftujuh8.com/ecommerces/v1/carts/delete/all",
        data: {
          "user_id": SharedPrefs.getUserId(),
        }
      );
    } catch(e) {
      debugPrint(e.toString());
      throw Exception("Failed to delete cart all");
    }
  }

   Future<void> deleteCartLiveAll() async {
    try {
      Dio dio = DioManager.shared.getClient();
      await dio.delete("https://api-ecommerce-general.inovatiftujuh8.com/ecommerces/v1/carts/live/delete/all",
        data: {
          "user_id": SharedPrefs.getUserId(),
        }
      );
    } catch(e) {
      debugPrint(e.toString());
      throw Exception("Failed to delete cart all");
    }
  }

  Future<void> updateQty({required String cartId, required int qty}) async {
    try {
      Dio dio = DioManager.shared.getClient();
      await dio.post("https://api-ecommerce-general.inovatiftujuh8.com/ecommerces/v1/update/qty",
        data: {
          "cart_id": cartId,
          "qty": qty
        }
      );
    } on DioError catch(e) {
      debugPrint(e.response!.data.toString());
    } catch(e) {
      debugPrint(e.toString());
      throw Exception('Failed to update qty');
    }
  }

  Future<void> updateSelected({
    required String cartId,
    required bool selected
  }) async {
    try {
      Dio dio = DioManager.shared.getClient();
      await dio.post("https://api-ecommerce-general.inovatiftujuh8.com/ecommerces/v1/update/selected",
        data: {
          "cart_id": cartId,
          "selected": selected
        }
      );
    } on DioError catch(e) {
      debugPrint(e.response!.data.toString());
    } catch(e) {
      debugPrint(e.toString());
      throw Exception("Failed to update selected");
    }
  }

  Future<void> updateSelectedAll({
    required bool selected
  }) async {
    try {
      Dio dio = DioManager.shared.getClient();
      await dio.post("https://api-ecommerce-general.inovatiftujuh8.com/ecommerces/v1/update/selected/all",
        data: {
          "user_id": SharedPrefs.getUserId(),
          "selected": selected
        }
      );
    } on DioError catch(e) {
      debugPrint(e.response!.data.toString());
    } catch(e) {
      debugPrint(e.toString());
      throw Exception("Failed to update selected all");
    }
  }
 
   Future<void> updateNote({required String cartId, required String note}) async {
    try {
      Dio dio = DioManager.shared.getClient();
      await dio.post("https://api-ecommerce-general.inovatiftujuh8.com/ecommerces/v1/update/note",
        data: {
          "cart_id": cartId,
          "note": note
        }
      );
    } catch(e) {
      debugPrint(e.toString());
      throw Exception('Failed to update note');
    }
  }

  Future<CheckoutListModel> getCheckoutList({required String from}) async {
    try {
      Dio dio = DioManager.shared.getClient();
      Response response = await dio.post("https://api-ecommerce-general.inovatiftujuh8.com/ecommerces/v1/checkout/list",
        data: {
          "user_id": SharedPrefs.getUserId(),
          "from": from
        }
      );
      Map<String, dynamic> data = response.data;
      CheckoutListModel checkoutListModel = CheckoutListModel.fromJson(data);
      return checkoutListModel;
    } on DioError catch(e) {
      debugPrint(e.response!.data.toString());
      throw Exception('Failed to get checkout list');
    } catch(e) {
      debugPrint(e.toString());
      throw Exception('Failed to get checkout list');
    }
  }

  Future<CourierListModel> getCourier({
    required String storeId,
    required String from
  }) async {
    try {
      Dio dio = DioManager.shared.getClient();
      Response response = await dio.post("https://api-ecommerce-general.inovatiftujuh8.com/ecommerces/v1/couriers/cost/list",
        data: {
          "store_id": storeId,
          "from": from,
          "user_id": SharedPrefs.getUserId()
        }
      );
      Map<String, dynamic> data = response.data;
      CourierListModel courierListModel = CourierListModel.fromJson(data);
      return courierListModel;
    } on DioError catch(e) {
      ShowSnackbar.snackbar(e.response!.data["message"], "", ColorResources.error);
      throw Exception('Failed to get courier');
    } catch(e) {
      debugPrint(e.toString());
      throw Exception('Failed to get courier');
    }
  }

  Future<void> addCourier({
    required String courierCode,
    required String courierService,
    required String courierName,
    required String courierDesc,
    required String costValue,
    required String costNote,
    required String costEtd,
    required String storeId
  }) async {
    try { 
      Dio dio = DioManager.shared.getClient();

      final data = {
        "courier_code": courierCode,
        "courier_service": courierService,
        "courier_name": courierName,
        "courier_description": courierDesc,
        "cost_value": costValue,
        "cost_note": costNote,
        "cost_etd": costEtd,
        "user_id": SharedPrefs.getUserId(),
        "store_id": storeId
      };

      await dio.post("https://api-ecommerce-general.inovatiftujuh8.com/ecommerces/v1/couriers/add",
        data: data
      );

    } catch(e) {
      debugPrint(e.toString());
      throw Exception('Failed to add courier');
    }
  } 

  Future<void> clearCourier() async {
    try { 
      Dio dio = DioManager.shared.getClient();

      final data = {
        "user_id": SharedPrefs.getUserId(),
      };

      await dio.post("https://api-ecommerce-general.inovatiftujuh8.com/ecommerces/v1/couriers/clear",
        data: data
      );

    } catch(e) {
      debugPrint(e.toString());
      throw Exception('Failed to clear courier');
    }
  }

  Future<ShippingAddressModel> getShippingAddressList() async {
    try {
      Dio dio = DioManager.shared.getClient();
      Response response = await dio.post("https://api-ecommerce-general.inovatiftujuh8.com/ecommerces/v1/shipping/address",
        data: {
          "user_id": SharedPrefs.getUserId(),
          "default_location": false
        }
      );
      Map<String, dynamic> data = response.data;
      ShippingAddressModel shippingAddressModel = ShippingAddressModel.fromJson(data);
      return shippingAddressModel;
    } catch(e) {
      debugPrint(e.toString());
      throw Exception('Failed to get shipping address list');
    }
  }

  Future<void> createShippingAddress({
    required String label,
    required String address,
    required String province,
    required String city,
    required String district,
    required String subdistrict,
    required String postalCode
  }) async {
    try {
      Dio dio = DioManager.shared.getClient();
      await dio.post("https://api-ecommerce-general.inovatiftujuh8.com/ecommerces/v1/shipping/address/store",
        data: {
          "name": label,
          "address": address,
          "province": province,
          "city": city,
          "district": district,
          "subdistrict": subdistrict,
          "postal_code": postalCode,
          "default_location": false,
          "user_id": SharedPrefs.getUserId()
        }
      );
    } catch(e) {
      debugPrint(e.toString());
      throw Exception('Failed to create shipping address');
    }
  }

  Future<void> deleteShippingAddress({
    required String id
  }) async {
    try {
      Dio dio = DioManager.shared.getClient();
      await dio.delete("https://api-ecommerce-general.inovatiftujuh8.com/ecommerces/v1/shipping/address/delete/$id");
    } catch(e) {
      debugPrint(e.toString());
      throw Exception('Failed to delete shipping address');
    }
  }

  Future<void> updateShippingAddress({
    required String id,
    required String label,
    required String address,
    required String province,
    required String city,
    required String district,
    required String subdistrict,
    required String postalCode
  }) async {
    try {
      Dio dio = DioManager.shared.getClient();
      await dio.put("https://api-ecommerce-general.inovatiftujuh8.com/ecommerces/v1/shipping/address/update/$id",
        data: {
          "name": label,
          "address": address,
          "province": province,
          "city": city,
          "district": district,
          "subdistrict": subdistrict,
          "postal_code": postalCode,
          "default_location": false,
        }
      );
    } catch(e) {
      debugPrint(e.toString());
      throw Exception('Failed to load update shipping address');
    }
  }

  Future<void> selectPrimaryAddress({
    required String id
  }) async {
     try {
      Dio dio = DioManager.shared.getClient();
      await dio.put("https://api-ecommerce-general.inovatiftujuh8.com/ecommerces/v1/shipping/address/primary/select/$id",
        data: {
          "user_id": SharedPrefs.getUserId(),
        }
      );
    } catch(e) {
      debugPrint(e.toString());
      throw Exception('Failed to load select primary address');
    }
  }

  Future<HowToPaymentModel> howToPayment({required String channelId}) async {
    try {
      Dio dio = DioManager.shared.getClient();
      Response response = await dio.post("https://api-ecommerce-general.inovatiftujuh8.com/ecommerces/v1/payment/how-to",
        data: {
          "channel_id": channelId
        }
      );
      Map<String, dynamic> data = response.data;
      HowToPaymentModel howToPaymentModel = HowToPaymentModel.fromJson(data);
      return howToPaymentModel;
    } catch(e) {
      debugPrint(e.toString());
      throw Exception('Failed to load how to payment');
    }
  } 
 
  Future<ShippingAddressModelDefault> getShippingAddressDefault() async {
    try {
      Dio dio = DioManager.shared.getClient();
      Response response = await dio.post("https://api-ecommerce-general.inovatiftujuh8.com/ecommerces/v1/shipping/address/default",
        data: {
          "user_id": SharedPrefs.getUserId(),
        }
      );
      Map<String, dynamic> data = response.data;
      ShippingAddressModelDefault shippingAddressModelDefault = ShippingAddressModelDefault.fromJson(data);
      return shippingAddressModelDefault;
    } catch(e) {
      debugPrint(e.toString());
      throw Exception('Failed to load shipping address default');
    }
  }

  Future<ShippingAddressModelDetail> getShippingAddressDetail({required String id}) async {
    try {
      Dio dio = DioManager.shared.getClient();
      Response response = await dio.get("https://api-ecommerce-general.inovatiftujuh8.com/ecommerces/v1/shipping/address/$id");
      Map<String, dynamic> data = response.data;
      ShippingAddressModelDetail shippingAddressModelDetail = ShippingAddressModelDetail.fromJson(data);
      return shippingAddressModelDetail;
    } catch(e) {
      debugPrint(e.toString());
      throw Exception('Failed to load shipping address detail');
    }
  }
  
  Future<ProvinceModel> getProvince({required String search}) async {
    try {
      Dio dio = DioManager.shared.getClient();
      Response response = await dio.get("https://api-ecommerce-general.inovatiftujuh8.com/ecommerces/v1/regions/province?search=$search");
      Map<String, dynamic> data = response.data;
      ProvinceModel provinceModel = ProvinceModel.fromJson(data);
      return provinceModel;
    } catch(e) {
      debugPrint(e.toString());
      throw Exception("Failed to load province");
    }
  }

  Future<CityModel> getCity({
    required String provinceName, 
    required String search
  }) async {
    try {
      Dio dio = DioManager.shared.getClient();
      Response response = await dio.get("https://api-ecommerce-general.inovatiftujuh8.com/ecommerces/v1/regions/city/$provinceName?search=$search");
      Map<String, dynamic> data = response.data;
      CityModel cityModel = CityModel.fromJson(data);
      return cityModel;
    } catch(e) {
      debugPrint(e.toString());
      throw Exception("Failed to load city");
    }
  }

  Future<DistrictModel> getDistrict({
    required String cityName,
    required String search
  }) async {
    try { 
      Dio dio = DioManager.shared.getClient();
      Response response = await dio.get("https://api-ecommerce-general.inovatiftujuh8.com/ecommerces/v1/regions/district/$cityName?search=$search");
      Map<String, dynamic> data = response.data;
      DistrictModel districtModel = DistrictModel.fromJson(data);
      return districtModel;
    } catch(e) {
      debugPrint(e.toString());
      throw Exception("Failed to load district");
    }
  }  

  Future<SubdistrictModel> getSubdistrict({
    required String districtName,
    required String search
  }) async {
    try {
      Dio dio = DioManager.shared.getClient();
      Response response = await dio.get("https://api-ecommerce-general.inovatiftujuh8.com/ecommerces/v1/regions/subdistrict/$districtName?search=$search");
      Map<String, dynamic> data = response.data;
      SubdistrictModel subdistrictModel = SubdistrictModel.fromJson(data);
      return subdistrictModel;
    } catch(e) {
      debugPrint(e.toString());
      throw Exception("Failed to load subdistrict");
    }
  }

  Future<PaymentChannelModel> getPaymentChannel() async {
    try {
      Dio dio = DioManager.shared.getClient();
      Response response = await dio.get("https://api-ecommerce-general.inovatiftujuh8.com/ecommerces/v1/payment-channel");
      Map<String, dynamic> data = response.data;
      PaymentChannelModel paymentChannelModel = PaymentChannelModel.fromJson(data);
      return paymentChannelModel;
    } catch(e) {
      debugPrint(e.toString());
      throw Exception("Failed to load payment");
    }
  } 

  Future<ResponseMidtransVa> pay({
    required String app, 
    required String from,
    required int channelId,
    required String platform,
    required String paymentCode,
    required int amount
  }) async {
    try {
      final dataObj = {
        "user_id": SharedPrefs.getUserId(),
        "app": app, 
        "from": from,
        "channel_id": channelId,
        "platform": platform,
        "payment_code": paymentCode, 
        "amount": amount
      };
      Dio dio = DioManager.shared.getClient();
      Response response = await dio.post("https://api-ecommerce-general.inovatiftujuh8.com/ecommerces/v1/pay",
        data: dataObj
      );
      Map<String, dynamic> data = response.data;
      ResponseMidtransVa responseMidtransVa = ResponseMidtransVa.fromJson(data);
      return responseMidtransVa;
    } on DioError catch(e) {
      debugPrint(e.response!.toString());
      ShowSnackbar.snackbar("Hmm... Mohon tunggu yaa", "", ColorResources.error);
      throw Exception("Failed to pay");
    } catch(e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      throw Exception("Failed to pay");
    }
  }

  Future<ResponseMidtransEmoney> EmoneyPay({
    required String app, 
    required String from,
    required int channelId,
    required String platform,
    required String paymentCode,
    required int amount
  }) async {
    try {
      final dataObj = {
        "user_id": SharedPrefs.getUserId(),
        "app": app, 
        "from": from,
        "channel_id": channelId,
        "platform": platform,
        "payment_code": paymentCode, 
        "amount": amount
      };
      Dio dio = DioManager.shared.getClient();
      Response response = await dio.post("https://api-ecommerce-general.inovatiftujuh8.com/ecommerces/v1/pay",
        data: dataObj
      );
      Map<String, dynamic> data = response.data;
      ResponseMidtransEmoney responseMidtransEmoney = ResponseMidtransEmoney.fromJson(data);
      return responseMidtransEmoney;
    } on DioError catch(e) {
      debugPrint(e.response!.toString());
      ShowSnackbar.snackbar("Hmm... Mohon tunggu yaa", "", ColorResources.error);
      throw Exception("Failed to pay");
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw Exception("Failed to pay");
    }
  }

  Future<ResponseMidtransVa> payTopup({
    required String app, 
    required int channelId,
    required String platform,
    required String paymentCode,
    required int amount
  }) async {
    try {
      final dataObj = {
        "user_id": SharedPrefs.getUserId(),
        "app": app, 
        "channel_id": channelId,
        "platform": platform,
        "payment_code": paymentCode, 
        "amount": amount
      };
      Dio dio = DioManager.shared.getClient();
      Response response = await dio.post("https://api-ecommerce-general.inovatiftujuh8.com/ecommerces/v1/topup/balance",
        data: dataObj
      );
      Map<String, dynamic> data = response.data;
      ResponseMidtransVa responseMidtransVa = ResponseMidtransVa.fromJson(data);
      return responseMidtransVa;
    } on DioError catch(e) {
      debugPrint(e.response!.toString());
      ShowSnackbar.snackbar("Hmm... Mohon tunggu yaa", "", ColorResources.error);
      throw Exception("Failed to pay");
    } catch(e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      throw Exception("Failed to pay");
    }
  }

  Future<StoreModel> getStore() async {
    try {
      Dio dio = DioManager.shared.getClient();
      Response res = await dio.post("https://api-ecommerce-general.inovatiftujuh8.com/ecommerces/v1/stores",
        data: {
          "user_id": SharedPrefs.getUserId()
        }
      );
      Map<String, dynamic> data = res.data;
      StoreModel storeModel = StoreModel.fromJson(data);
      return storeModel;
    } on DioError catch(e) {
      debugPrint(e.response!.data.toString());
      throw Exception("Failed Get Store");
    } catch(e, stacktrace) {  
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      throw Exception("Failed Get Store");
    }
  }

  Future<void> createStore({
    required String id,
    required String logo,
    required String name,
    required String caption,
    required String province, 
    required String city,
    required String district,
    required String subdistrict,
    required String address,
    required String email,
    required String phone,
    required String lat, 
    required String lng,
    required bool isOpen,
    required String postCode,
  }) async {
    try {
      var dataObj = {
        "id": id,
        "logo": logo,
        "name": name,
        "description": caption,
        "province": province,
        "city": city,
        "district": district,
        "subdistrict": subdistrict,
        "address": address,
        "email": email,
        "phone": phone,
        "lat": lat, 
        "lng": lng,
        "is_open": isOpen,
        "postal_code": postCode,
        "user_id": SharedPrefs.getUserId(),
        "app_name": "hp3ki"
      };      
      Dio dio = DioManager.shared.getClient();
      await dio.post("https://api-ecommerce-general.inovatiftujuh8.com/ecommerces/v1/stores/assign",
        data: dataObj
      );
    } on DioError catch(e) {
      debugPrint(e.response!.toString());
      ShowSnackbar.snackbar("Hmm... Mohon tunggu yaa", "", ColorResources.error);
      throw Exception("Failed Create Store");
    } catch(e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      throw Exception("Failed Create Store");
    }
  }

  Future<OwnerModel> checkStoreOwner() async {
    try {
      Dio dio = DioManager.shared.getClient();
      Response response = await dio.post("https://api-ecommerce-general.inovatiftujuh8.com/ecommerces/v1/stores/owner",
        data: {
          "user_id": SharedPrefs.getUserId()
        }
      );
      Map<String, dynamic> data = response.data;
      OwnerModel ownerModel = OwnerModel.fromJson(data);
      return ownerModel;
    } on DioError catch(e) {
      debugPrint(e.response!.toString());
      ShowSnackbar.snackbar("Hmm... Mohon tunggu yaa", "", ColorResources.error);
      throw Exception("Failed Check Store Owner");
    } catch(e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      throw Exception("Failed Check Store Owner");
    }
  } 

  Future<ResponseMidtransEmoney> EmoneyPayTopup({
    required String app, 
    required int channelId,
    required String platform,
    required String paymentCode,
    required int amount
  }) async {
    try {
      final dataObj = {
        "user_id": SharedPrefs.getUserId(),
        "app": app,
        "channel_id": channelId,
        "platform": platform,
        "payment_code": paymentCode,
        "amount": amount
      };
      Dio dio = DioManager.shared.getClient();
      Response response = await dio.post("https://api-ecommerce-general.inovatiftujuh8.com/ecommerces/v1/topup/balance",
        data: dataObj
      );
      Map<String, dynamic> data = response.data;
      ResponseMidtransEmoney responseMidtransEmoney = ResponseMidtransEmoney.fromJson(data);
      return responseMidtransEmoney;
    } on DioError catch(e) {
      debugPrint(e.response!.toString());
      ShowSnackbar.snackbar("Hmm... Mohon tunggu yaa", "", ColorResources.error);
      throw Exception("Failed to pay");
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw Exception("Failed to pay");
    }
  }

}