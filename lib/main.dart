import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:flutter_mentions/flutter_mentions.dart';

import 'package:hp3ki/data/models/language/language.dart';
import 'package:hp3ki/providers/firebase/firebase.dart';
import 'package:hp3ki/providers/internet/internet.dart';
import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/shared_preferences.dart';

import 'package:responsive_framework/responsive_framework.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:hp3ki/container.dart' as core;
import 'package:hp3ki/providers.dart';
import 'package:hp3ki/providers/localization/localization.dart';
import 'package:hp3ki/services/notification.dart';
import 'package:hp3ki/localization/app_localization.dart';
import 'package:hp3ki/utils/constant.dart';
import 'package:hp3ki/views/screens/splash/splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  await core.init();
  await SharedPrefs.init();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  timeago.setLocaleMessages('id', CustomLocalDate());
  runApp(MultiProvider(
    providers: providers,
    child: const AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light, child: MyApp()),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Future<void> getData() async {
    if (mounted) {
      NotificationService.init();
    }
    if (mounted) {
      context.read<FirebaseProvider>().setupInteractedMessage(context);
    }
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

  @override
  void didChangeDependencies() {
    if (mounted) {
      context.read<InternetProvider>().connectingToInternet();
    }

    super.didChangeDependencies();
  }

  void listenOnClickNotifications() => NotificationService.onNotifications.stream.listen(onClickedNotification);

  void onClickedNotification(String? payload) {
    
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    getData();
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
    return Portal(
      child: MaterialApp(
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
              ]);
        },
        localizationsDelegates: const [
          AppLocalization.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: locals,
        home: const SplashScreen(),
      ),
    );
  }
}
