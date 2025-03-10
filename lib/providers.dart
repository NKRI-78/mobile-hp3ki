import 'package:hp3ki/providers/ecommerce/ecommerce.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

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
import 'package:hp3ki/providers/localization/localization.dart';
import 'package:hp3ki/providers/location/location.dart';
import 'package:hp3ki/providers/maintenance/maintenance.dart';
import 'package:hp3ki/providers/media/media.dart';
import 'package:hp3ki/providers/membernear/membernear.dart';
import 'package:hp3ki/providers/news/news.dart';
import 'package:hp3ki/providers/ppob/ppob.dart';
import 'package:hp3ki/providers/profile/profile.dart';
import 'package:hp3ki/providers/region_dropdown/region_dropdown.dart';
import 'package:hp3ki/providers/sos/sos.dart';
import 'package:hp3ki/providers/splash/splash.dart';
import 'package:hp3ki/providers/upgrade_member/upgrade_member.dart';

import 'container.dart' as c;

List<SingleChildWidget> providers = [
  ...independentServices,
];

List<SingleChildWidget> independentServices = [
  ChangeNotifierProvider(create: (_) => c.getIt<FirebaseProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<SplashProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<NewsProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<InternetProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<LocalizationProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<PPOBProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<LocationProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<MembernearProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<SosProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<InboxProvider>()),    
  ChangeNotifierProvider(create: (_) => c.getIt<FeedDetailProviderV2>()),
  ChangeNotifierProvider(create: (_) => c.getIt<FeedProviderV2>()),
  ChangeNotifierProvider(create: (_) => c.getIt<FeedDetailProviderV2>()),
  ChangeNotifierProvider(create: (_) => c.getIt<FeedReplyProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<EventProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<EcommerceProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<CheckInProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<AuthProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<ProfileProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<MediaProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<MaintenanceProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<RegionDropdownProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<BannerProvider>()),
  ChangeNotifierProvider(create: (_) => c.getIt<UpgradeMemberProvider>()),
  
  Provider.value(value: const <String, dynamic>{})
];
