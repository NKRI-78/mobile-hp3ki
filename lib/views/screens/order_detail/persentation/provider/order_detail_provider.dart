import 'package:flutter/material.dart';
import 'package:hp3ki/views/screens/order_detail/data/order_detail_model.dart';
import 'package:hp3ki/views/screens/order_detail/domain/order_detail_repository.dart';
import 'package:hp3ki/views/screens/order_detail/persentation/widgets/review_order_widget.dart';

import 'package:uuid/uuid.dart';

class OrderDetailProvider with ChangeNotifier {
  final OrderDetailRepository repo;
  final String orderId;

  OrderDetailProvider({required this.repo, required this.orderId});

  OrderDetailModel? detail;
  bool loading = true;
  bool loadingFinishOrder = false;

  bool get isCanReview => detail?.order.status == "FINISHED"
      ? detail!.orderItems
              .where((element) => element.orderItemStatus == null)
              .isNotEmpty
          ? true
          : false
      : false;

  Future<void> getDetail() async {
    try {
      detail = await repo.getDetail(orderId);
    } catch (e) {
      ///
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> finishOrder() async {
    try {
      loadingFinishOrder = true;
      notifyListeners();
      await repo.finishOrder(orderId);
      await getDetail();
    } catch (e) {
      rethrow;
    } finally {
      loadingFinishOrder = false;
      notifyListeners();
    }
  }

  Future<void> reviewOrder(Map<String, OrderReviewHelper> review) async {
    try {
      Map<String, Map<String, dynamic>> reviews = {};
      await Future.forEach(review.entries, (rev) async {
        List<String> paths = [];
        for (var file in rev.value.files) {
          paths.add(await repo.uploadMedia(file));
        }

        reviews[rev.key] = {
          "uid": const Uuid().v4(),
          "caption": rev.value.caption,
          "rating": rev.value.rating.toString(),
          "files": paths,
        };
      });

      await repo.submitReview(orderId, reviews);
    } catch (e) {
      rethrow;
    }
  }
}
