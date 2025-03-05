import 'dart:async';

import 'package:flutter/services.dart';
import 'package:hp3ki/providers/maintenance/maintenance.dart';
import 'package:hp3ki/utils/constant.dart';
import 'package:hp3ki/utils/dio.dart';
import 'package:hp3ki/utils/shared_preferences.dart';
import 'package:hp3ki/views/screens/auth/sign_in.dart';
import 'package:hp3ki/views/screens/comingsoon/comingsoon.dart';
import 'package:hp3ki/views/screens/home/home.dart';
import 'package:hp3ki/views/screens/onboarding/onboarding.dart';
// import 'package:hp3ki/views/screens/update/update.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
// import 'package:new_version_plus/new_version_plus.dart';
import 'package:hp3ki/localization/language_constraints.dart';
import 'package:hp3ki/services/navigation.dart';
import 'package:hp3ki/providers/splash/splash.dart';
import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/utils/dimensions.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  PackageInfo packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'com.inovatif78.hp3ki',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

  Future<void> initPackageInfo() async {
    PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      if (mounted) {
        packageInfo = info;
      }
    });
  }

  void getData() {
    // if (mounted) {
    //   NewVersionPlus newVersion = NewVersionPlus(
    //       androidId: 'com.inovatif78.hp3ki', iOSId: 'com.inovatif78.hp3ki');
    //   Future.delayed(Duration.zero, () async {
    //     VersionStatus? vs = await newVersion.getVersionStatus();
    //     if (vs?.canUpdate ?? false) {
    //       NS.pushReplacement(context, const UpdateScreen());
    //     }
    //   });
    // }
    if (mounted) {
      context.read<SplashProvider>().getMaintenanceStatus(context);
    }
    if (mounted) {
      context.read<MaintenanceProvider>().getDemoStatus(context);
    }
  }

  Future<bool> checkIsAppleReview() async {
    try {
      final res = await DioManager.shared
          .getClient()
          .get("${AppConstants.baseUrl}/api/v1/dev/apple-review");

      bool data = res.data['is_review'] ?? false;
      return data;
    } catch (e) {
      return false;
    }
  }

  void navigateScreen() async {
    final bool isAppleReview = await checkIsAppleReview();

    Future.delayed(Duration.zero, () {
      if (mounted) {
        context.read<SplashProvider>().initConfig().then((_) {
          if (context.read<SplashProvider>().isMaintenance == true) {
            NS.pushReplacement(
                context,
                const ComingSoonScreen(
                  title: 'HP3KI',
                  isMaintenance: true,
                  isNavbarItem: true,
                ));
          } else if (context.read<SplashProvider>().isSkipOnboarding()) {
            if (isAppleReview) {
              NS.pushReplacement(context, const DashboardScreen());
              return;
            }
            if (SharedPrefs.isLoggedIn()) {
              NS.pushReplacement(context, const DashboardScreen());
            } else {
              NS.pushReplacement(context, const SignInScreen());
            }
          } else {
            NS.pushReplacement(context, const OnboardingScreen());
          }
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initPackageInfo();

    Future.microtask(() {
      getData();
    });

    Timer(const Duration(seconds: 3), () {
      navigateScreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return buildUI();
  }

  Widget buildUI() {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: SafeArea(child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Container(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height,
              decoration: const BoxDecoration(
                  backgroundBlendMode: BlendMode.darken,
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [ColorResources.black, Color(0xff0B1741)]),
                  image: DecorationImage(
                      image: AssetImage('assets/images/background/bg.png'),
                      fit: BoxFit.cover)),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/images/logo/splash-aspro.png',
                      width: 400.0,
                      height: 400.0,
                    ),
                  ),
                  Positioned(
                      left: 0.0,
                      right: 0.0,
                      bottom: 30.0,
                      child: Center(
                        child: Text(
                          "${getTranslated("VERSION", context)} ${packageInfo.version}",
                          style: poppinsRegular.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: Dimensions.fontSizeLarge,
                              color: ColorResources.white),
                          textAlign: TextAlign.center,
                        ),
                      ))
                ],
              ),
            );
          },
        )),
      ),
    );
  }
}
