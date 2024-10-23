import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:hp3ki/data/repository/ecommerce/ecommerce.dart';
import 'package:hp3ki/providers/ecommerce/ecommerce.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:hp3ki/data/repository/auth/auth.dart';
import 'package:hp3ki/data/repository/banner/banner.dart';
import 'package:hp3ki/data/repository/checkin/checkin.dart';
import 'package:hp3ki/data/repository/event/event.dart';
import 'package:hp3ki/data/repository/feed/feed.dart';
import 'package:hp3ki/data/repository/feedv2/feed.dart';
import 'package:hp3ki/data/repository/firebase/firebase.dart';
import 'package:hp3ki/data/repository/inbox/inbox.dart';
import 'package:hp3ki/data/repository/maintenance/maintenance.dart';
import 'package:hp3ki/data/repository/media/media.dart';
import 'package:hp3ki/data/repository/membernear/membernear.dart';
import 'package:hp3ki/data/repository/ppob_v2/ppob_v2.dart';
import 'package:hp3ki/data/repository/profile/profile.dart';
import 'package:hp3ki/data/repository/region_dropdown/region_dropdown.dart';
import 'package:hp3ki/data/repository/sos/sos.dart';
import 'package:hp3ki/data/repository/upgrade_member/upgrade_member.dart';
import 'package:hp3ki/data/repository/news/news.dart';

import 'package:hp3ki/providers/localization/localization.dart';
import 'package:hp3ki/providers/location/location.dart';
import 'package:hp3ki/providers/maintenance/maintenance.dart';
import 'package:hp3ki/providers/media/media.dart';
import 'package:hp3ki/providers/membernear/membernear.dart';
import 'package:hp3ki/providers/news/news.dart';
import 'package:hp3ki/providers/ppob/ppob.dart';
import 'package:hp3ki/providers/auth/auth.dart';
import 'package:hp3ki/providers/banner/banner.dart';
import 'package:hp3ki/providers/checkin/checkin.dart';
import 'package:hp3ki/providers/event/event.dart';
import 'package:hp3ki/providers/feedv2/feed.dart';
import 'package:hp3ki/providers/feedv2/feedDetail.dart';
import 'package:hp3ki/providers/feedv2/feedReply.dart';
import 'package:hp3ki/providers/firebase/firebase.dart';
import 'package:hp3ki/providers/inbox/inbox.dart';
import 'package:hp3ki/providers/internet/internet.dart';
import 'package:hp3ki/providers/profile/profile.dart';
import 'package:hp3ki/providers/region_dropdown/region_dropdown.dart';
import 'package:hp3ki/providers/sos/sos.dart';
import 'package:hp3ki/providers/splash/splash.dart';
import 'package:hp3ki/providers/upgrade_member/upgrade_member.dart';

final getIt = GetIt.instance;

Future<void> init() async {

  // REPOSITORY
  
  getIt.registerLazySingleton(() => EcommerceRepo(
    sp: getIt()
  ));
  getIt.registerLazySingleton(() => FeedRepo(
    sp: getIt(),
  ));
  getIt.registerLazySingleton(() => FeedRepoV2(
    sp: getIt(),
  ));
  getIt.registerLazySingleton(() => NewsRepo(
    dioClient: null,
  ));
  getIt.registerLazySingleton(() => MembernearRepo(
    dioClient: null,
  ));
  getIt.registerLazySingleton(() => SosRepo(
    dioClient: null,
  ));
  getIt.registerLazySingleton(() => InboxRepo(
    dioClient: null,
  ));  
  getIt.registerLazySingleton(() => CheckInRepo(
    dioClient: null,
  ));
  getIt.registerLazySingleton(() => EventRepo(
    dioClient: null,
  ));
  getIt.registerLazySingleton(() => FirebaseRepo(
    dioClient: null,
  ));
  getIt.registerLazySingleton(() => ProfileRepo(
    dioClient: null,
  ));
  getIt.registerLazySingleton(() => AuthRepo(
    dioClient: null,
  ));
  getIt.registerLazySingleton(() => MediaRepo());
  getIt.registerLazySingleton(() => MaintenanceRepo(
    dioClient: null,
  ));
  getIt.registerLazySingleton(() => RegionDropdownRepo(
    dioClient: null,
  ));
  getIt.registerLazySingleton(() => BannerRepo(
    dioClient: null,
  ));
  getIt.registerLazySingleton(() => UpgradeMemberRepo(
    dioClient: null,
  ));
  getIt.registerLazySingleton(() => PPOBRepo(
    dioClient: null,
  ));

  // PROVIDER

  getIt.registerFactory(() => FirebaseProvider(
    fr: getIt(),
  ));
  getIt.registerFactory(() => EcommerceProvider(
    er: getIt(),
    mr: getIt()
  ));
  getIt.registerFactory(() => SplashProvider(
    mr: getIt(),
  ));
  getIt.registerFactory(() => InternetProvider());
  getIt.registerFactory(() => LocalizationProvider());
  getIt.registerFactory(() => AuthProvider(
    ar: getIt(),
  ));
  getIt.registerFactory(() => NewsProvider(
    nr: getIt(),
  ));
  getIt.registerFactory(() => PPOBProvider(
    pr: getIt(),
  ));
  getIt.registerFactory(() => LocationProvider());
  getIt.registerFactory(() => MembernearProvider(
    lp: getIt(),
    nr: getIt(),
  ));
  getIt.registerFactory(() => SosProvider(
    sr: getIt(),
    lp: getIt(),
  ));
  getIt.registerFactory(() => InboxProvider(
    ir: getIt(),
  ));
  getIt.registerFactory(() => FeedDetailProviderV2(
    ar: getIt(),
    fr: getIt(),
  ));
  getIt.registerFactory(() => FeedProviderV2(
    ar: getIt(),
    fr: getIt()
  ));
  getIt.registerFactory(() => FeedReplyProvider(
    ar: getIt(),
    fr: getIt(),
  ));
  getIt.registerFactory(() => CheckInProvider(
    cr: getIt(),
    lp: getIt(),
  ));
  getIt.registerFactory(() => EventProvider(
    er: getIt(),
  ));
  getIt.registerFactory(() => ProfileProvider(
    ap: getIt(),
    pr: getIt(),
  ));
  getIt.registerLazySingleton(() => MediaProvider(
    mr: getIt(),
  ));
  getIt.registerLazySingleton(() => MaintenanceProvider(
    mr: getIt(),
  ));
  getIt.registerLazySingleton(() => RegionDropdownProvider(
    rr: getIt(),
  ));
  getIt.registerLazySingleton(() => BannerProvider(
    br: getIt(),
  ));
  getIt.registerLazySingleton(() => UpgradeMemberProvider(
    umr: getIt(),
  ));

  SharedPreferences sp = await SharedPreferences.getInstance();

  getIt.registerLazySingleton(() => sp);
  getIt.registerLazySingleton(() => Dio());
}
