import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:hp3ki/data/models/language/language.dart';
import 'package:hp3ki/providers/firebase/firebase.dart';
import 'package:hp3ki/services/services.dart';
import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/shared_preferences.dart';
import 'package:hp3ki/views/screens/calendar/calendar.dart';
import 'package:hp3ki/views/screens/feed/post_detail.dart';
import 'package:hp3ki/views/screens/news/detail.dart';
import 'package:hp3ki/views/screens/notification/detail.dart';

import 'package:responsive_framework/responsive_framework.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:hp3ki/container.dart' as core;


import 'package:hp3ki/providers.dart';
import 'package:hp3ki/providers/localization/localization.dart';

import 'package:hp3ki/services/navigation.dart';
import 'package:hp3ki/services/notification.dart';

import 'package:hp3ki/localization/app_localization.dart';

import 'package:hp3ki/utils/constant.dart';

import 'package:hp3ki/views/screens/home/home.dart';
import 'package:hp3ki/views/screens/splash/splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // PlatformDispatcher.instance.onError = (error, stack) {
  //   FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  //   return true;
  // };

  await core.init();

  await SharedPrefs.init();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  timeago.setLocaleMessages('id', CustomLocalDate());

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    debugPrint(details.stack.toString());
  };

  runApp(MultiProvider(
    providers: providers,
    child: const AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light, child: MyApp()
    ),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {

  Future<void> getData() async {
    if (!mounted) return;
      await NotificationService.init();

    if (!mounted) return;
      await context.read<FirebaseProvider>().setupInteractedMessage(context);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    /* Lifecycle */
    // - Resumed (App in Foreground)
    // - Inactive (App Partially Visible - App not focused)
    // - Paused (App in Background)
    // - Detached (View Destroyed - App Closed)
    if (state == AppLifecycleState.resumed) {
      debugPrint("=== APP RESUME ===");
    }
    if (state == AppLifecycleState.inactive) {
      debugPrint("=== APP INACTIVE ===");
    }
    if (state == AppLifecycleState.paused) {
      debugPrint("=== APP PAUSED ===");
    }
    if (state == AppLifecycleState.detached) {
      debugPrint("=== APP CLOSED ===");
    }
  }

  void listenOnClickNotifications() => NotificationService.onNotifications.stream.listen(onClickedNotification);

  void onClickedNotification(NotificationResponse payload) {
    var data = json.decode(payload.payload!);

    // NEWS
    if(data["click_action"] == "news") {
      NS.push(navigatorKey.currentContext!, 
        NewsDetailScreen(newsId: data["news_id"])
      );
    }

    // BROADCAST
    if(data["click_action"] == "broadcast") {
      NS.push(navigatorKey.currentContext!, 
        DetailInboxScreen(
          inboxId: data["inbox_id"],
          type: "broadcast",
        )
      );
    }

    // SOS
    if(data["click_action"] == "sos") {
      NS.push(
        navigatorKey.currentContext!,
        DetailInboxScreen(
          inboxId: data["inbox_id"], 
          type: data["inbox_type"]
        )
      );    
    }

    // EVENT
    if(data["click_action"] == "event") {
      NS.push(navigatorKey.currentContext!,
        const CalendarScreen()
      );
    }

    // FORUM
    if(data["click_action"] == "create") {
      NS.push(navigatorKey.currentContext!,
        const DashboardScreen(index: 2)
      );
    }

    if(data["click_action"] == "like") {
      NS.push(navigatorKey.currentContext!,
        const DashboardScreen(index: 2)
      );
    }

    if(data["click_action"] == "comment-like") {
      NS.push(navigatorKey.currentContext!,
        const DashboardScreen(index: 2)
      );
    }

    if(data["click_action"] == "create-comment") {
      NS.pushUntil(
        navigatorKey.currentContext!, 
        PostDetailScreen(
          data: {
            "forum_id": data["forum_id"],
            "comment_id": data["comment_id"],
            "reply_id": "-",
            "from": "notification-comment",
          }, from: "notification-comment",
        )
      );
    }

    if(data["click_action"] == "create-reply") {
      NS.pushUntil(
        navigatorKey.currentContext!, 
        PostDetailScreen(
          data: {
            "forum_id": data["forum_id"],
            "comment_id": data["comment_id"],
            "reply_id": data["reply_id"],
            "from": "notification-reply",
          },
          from: "notification-reply",
        )
      );
    }
  }


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    Future.microtask(() => getData()); 

    context.read<FirebaseProvider>().listenNotification(context);

    listenOnClickNotifications();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    List<Locale> locals = [];

    for (LanguageModel language in AppConstants.languages) {
      locals.add(Locale(language.languageCode!, language.countryCode));
    }

    return MaterialApp(
      title: 'HP3KI',
      theme: ThemeData(
        useMaterial3: false,
        elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorResources.primary,
        )),
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      locale: context.watch<LocalizationProvider>().locale,
      builder: (BuildContext context, Widget? child) {
        return ResponsiveWrapper.builder(child,
          maxWidth: 1200.0,
          minWidth: 480.0,
          defaultScale: true,
          breakpoints: [
            const ResponsiveBreakpoint.resize(480.0, name: MOBILE),
            const ResponsiveBreakpoint.autoScale(800.0, name: TABLET),
            const ResponsiveBreakpoint.resize(1920.0, name: DESKTOP),
          ]
        );
      },
      localizationsDelegates: const [
        AppLocalization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: locals,
      home: const SplashScreen(),
    );
  }
}
