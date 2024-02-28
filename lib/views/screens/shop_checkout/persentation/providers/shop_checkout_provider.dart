// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:hp3ki/views/screens/payment_method/data/payment_method_model.dart';
import 'package:hp3ki/views/screens/product/data/models/product_checkout_model.dart';
import 'package:hp3ki/views/screens/shop_checkout/data/checkout_response_model.dart';
import 'package:hp3ki/views/screens/shop_checkout/data/raja_ongkir_cost_model.dart';
import 'package:hp3ki/views/screens/shop_checkout/domain/shop_checkout_repository.dart';
import 'package:hp3ki/views/screens/shop_checkout/persentation/pages/shop_checkout_page.dart';

class ShopCheckoutProvider with ChangeNotifier {
  final ShopCheckoutRepository repo;
  final ShopCheckoutType type;

  ProductCheckoutModel? productCheckout;

  Map<String, RoService> delivery = {};

  PaymentMethodModel? paymentMethod;

  bool loading = false;

  int get totalItem => productCheckout?.totalItem ?? 0;
  int get totalPrice => productCheckout?.totalPrice ?? 0;
  int get totalShippingPrice => delivery.entries.fold(
      0,
      (previousValue, element) =>
          previousValue + element.value.cost.first.value);

  bool get isAllShipiingSelected =>
      productCheckout?.stores.length == delivery.length;

  ShopCheckoutProvider({
    required this.repo,
    required this.type,
  });

  void init() {
    if (type == ShopCheckoutType.cart) {
      getProductFromCart();
    } else {
      getProductLive();
    }
  }

  Future<void> getProductFromCart() async {
    try {
      productCheckout = await repo.fetchProductFromCart();
      notifyListeners();
    } catch (e) {
      ///
    }
  }

  void removeAllDeliverySelect() {
    delivery = {};
    notifyListeners();
  }

  Future<void> getProductLive() async {
    try {
      productCheckout = await repo.fetchProductLive();
      notifyListeners();
    } catch (e) {
      ///
    }
  }

  Future<RajaOngkirCostModel> getCostList(String storeId) async {
    try {
      return repo.fetchCost(
          storeId: storeId,
          buyfrom: type == ShopCheckoutType.cart ? 'cart' : 'live');
    } catch (e) {
      rethrow;
    }
  }

  void setDeliveryPerStore(RoService roService, String storeId) {
    delivery[storeId] = roService;
    notifyListeners();
  }

  void setPaymentMethod(PaymentMethodModel payment) {
    paymentMethod = payment;
    notifyListeners();
  }

  Future<CheckoutResponseModel> checkout() async {
    try {
      loading = true;
      notifyListeners();
      return await repo.checkout(
        delivery: delivery,
        paymentMethod: paymentMethod!,
        buyFrom: type.name,
      );
    } catch (e) {
      loading = false;
      notifyListeners();
      rethrow;
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
