// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:hp3ki/views/screens/tracking_order/data/jne_tracking_model.dart';
import 'package:hp3ki/views/screens/tracking_order/domain/tracking_order_repository.dart';

class TrackingOrderProvider with ChangeNotifier {
  final TrackingOrderRepository repo;

  TrackingOrderProvider({
    required this.repo,
    required this.cnote,
  });

  final String cnote;

  JneTrackingModel? tracking;

  bool loading = true;

  int processIndex = 0;

  void init() {
    fetchTrackingOrder();
  }

  void fetchTrackingOrder() async {
    try {
      var trackings = await repo.getTracking(cnote);

      tracking = trackings;
      if (trackings.cnote.podStatus == "DELIVERY" ||
          trackings.cnote.podStatus == "ON PROCESS") {
        processIndex = 1;
      } else if (trackings.cnote.podStatus == "DELIVERED") {
        processIndex = 3;
      }
    } catch (e) {
      ///
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
