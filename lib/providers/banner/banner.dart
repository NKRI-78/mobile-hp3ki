import 'package:flutter/material.dart';
import 'package:hp3ki/data/models/banner/banner.dart';
import 'package:hp3ki/data/repository/banner/banner.dart';
import 'package:hp3ki/utils/exceptions.dart';

enum BannerStatus { idle, loading, loaded, error, empty }

class BannerProvider with ChangeNotifier {
  final BannerRepo br;

  BannerProvider({
    required this.br
  });

  BannerStatus _bannerStatus = BannerStatus.loading;
  BannerStatus get bannerStatus => _bannerStatus;

  List<BannerData>? _banners = [];
  List<BannerData>? get banners => _banners;

  void setStateBannerStatus(BannerStatus bannerStatus) {
    _bannerStatus = bannerStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future<void> getBanner(BuildContext context) async {
    setStateBannerStatus(BannerStatus.loading);
    try {   
      _banners = [];
      BannerModel? nm = await br.getBanner();
      if(nm!.data!.isNotEmpty) {
        _banners!.addAll(nm.data!);
        setStateBannerStatus(BannerStatus.loaded);
      } else {
        setStateBannerStatus(BannerStatus.empty);
      }
    } on CustomException catch(e) {
      debugPrint(e.toString());
      setStateBannerStatus(BannerStatus.error);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStateBannerStatus(BannerStatus.error);
    }
  }
}