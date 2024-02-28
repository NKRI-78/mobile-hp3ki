import 'package:flutter/material.dart';
import 'package:hp3ki/views/screens/my_store_order/data/order_model.dart';
import 'package:hp3ki/views/screens/my_store_order/domain/my_store_order_repository.dart';

enum OrderStatus {
  pending,
  confirm,
  shipping,
  delivered,
  finished,
  cancel,
}

class MyStoreOrderProvider with ChangeNotifier {
  final MyStoreOrderRepository repo;

  MyStoreOrderProvider({required this.repo});

  List<OrderModel> order = [];

  OrderStatus status = OrderStatus.pending;

  void init() async {
    fetchOrder();
  }

  void fetchOrder() async {
    try {
      order = await repo.getPendingOrder(status.name.toUpperCase());
      notifyListeners();
    } catch (e) {
      ///
    }
  }

  Future<void> cancelOrder(String orderId, String msg) async {
    try {
      await repo.cancelOrder(orderId, msg);
      fetchOrder();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> confirmOrder(String orderId) async {
    try {
      await repo.confirmOrder(orderId);
      fetchOrder();
    } catch (e) {
      rethrow;
    }
  }

  void changeStatus(OrderStatus e) {
    status = e;
    fetchOrder();
    notifyListeners();
  }
}
