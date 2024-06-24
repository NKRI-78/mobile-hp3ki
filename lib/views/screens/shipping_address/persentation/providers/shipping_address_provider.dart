import 'package:flutter/material.dart';
import 'package:hp3ki/views/screens/shipping_address/data/shipping_address_model.dart';
import 'package:hp3ki/views/screens/shipping_address/domain/shipping_address_repository.dart';

class ShippingAddressProvider with ChangeNotifier {
  final ShippingAddressRepository repo;
  List<ShippingAddressModel> list = [];

  ShippingAddressModel? get primaryAddress =>
      list.where((sa) => sa.defaultLocation == true).firstOrNull;

  ShippingAddressProvider({required this.repo});

  void fetchAllShippingAddress() async {
    try {
      list = await repo.getAllShippingAddress();
      notifyListeners();
    } catch (e) {
      ///
    }
  }

  Future<void> setPrimaryAddress(ShippingAddressModel data) async {
    await repo.setPrimaryAddress(data.shippingAddressId);
    fetchAllShippingAddress();
  }

  Future<void> deleteShippingAddress(ShippingAddressModel data) async {
    await repo.deleteShippingAddress(data.shippingAddressId);
    fetchAllShippingAddress();
  }
}
