import 'package:flutter/material.dart';
import 'package:hp3ki/views/screens/my_store/data/my_store_model.dart';
import 'package:hp3ki/views/screens/my_store/domain/my_store_repository.dart';

class MyStoreProvider with ChangeNotifier {
  final MyStoreRepository repo;

  MyStoreProvider({required this.repo, required this.storeId});

  int pendingOrderCount = 0;

  MyStoreModel? store;
  final String storeId;
  bool loading = true;

  void init() {
    fetchDetailStore();
    fetchCountPending();
  }

  void fetchCountPending() async {
    try {
      pendingOrderCount = await repo.getOrderPendingCount();
      // print(pendingOrderCount);
      notifyListeners();
    } catch (e) {
      // print(e.toString());
    }
  }

  void fetchDetailStore() async {
    try {
      store = await repo.getDetailStore(storeId);
    } catch (e) {
      ///
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
