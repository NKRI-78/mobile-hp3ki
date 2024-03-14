import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hp3ki/services/navigation.dart';
import 'package:hp3ki/views/screens/home/home.dart';
import 'package:provider/provider.dart';
import 'package:hp3ki/providers/splash/splash.dart';
import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/utils/dimensions.dart';
import 'package:hp3ki/views/basewidgets/button/custom.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController pageC;

  List<dynamic> onboarding = [
    {
      "id": 1,
      "title": "HP3KI Mobile Apps",
      "description":
          "Terdapat fitur-fitur yang dapat memudahkan kita untuk melakukan kegiatan di dalam organisasi",
      "image": "onboarding-1.png",
    },
    {
      "id": 2,
      "title": "Kewirausahaan",
      "description":
          "HP3KI bergerak untuk mengembangkan kewirausahaan dan usaha kecil dan menengah sehingga memiliki ketrampilan agar bisa menjadi kewirausahaan yang mandiri",
      "image": "onboarding-2.png",
    },
    {
      "id": 3,
      "title": "Community",
      "description":
          "Tempatnya Community untuk saling berinteraksi sesama anggota kapan pun dan dimana pun",
      "image": "onboarding-3.png",
    }
  ];

  @override
  void initState() {
    pageC = PageController();

    super.initState();
  }

  @override
  void dispose() {
    pageC.dispose();

    super.dispose();
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
            return PageView.builder(
                controller: pageC,
                pageSnapping: true,
                itemCount: onboarding.length,
                itemBuilder: (context, i) {
                  return Container(
                    width: MediaQuery.sizeOf(context).width,
                    height: MediaQuery.sizeOf(context).height,
                    padding: const EdgeInsets.all(60.0),
                    decoration: BoxDecoration(
                        backgroundBlendMode: BlendMode.darken,
                        gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [ColorResources.black, Color(0xff0B1741)]),
                        image: DecorationImage(
                            image: AssetImage(
                                'assets/images/onboarding/${onboarding[i]["image"]}'),
                            fit: BoxFit.cover)),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(),
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                'assets/images/logo/logo.png',
                                width: 120.0,
                                height: 120.0,
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              onboarding[i]["id"] == 1
                                  ? Text(
                                      'Selamat Datang di',
                                      style: poppinsRegular.copyWith(
                                        color: ColorResources.white,
                                        fontSize: Dimensions.fontSizeOverLarge,
                                      ),
                                    )
                                  : Container(),
                              Text(
                                onboarding[i]["title"],
                                style: poppinsRegular.copyWith(
                                  color: ColorResources.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 32.0,
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              Text(
                                onboarding[i]["description"],
                                style: poppinsRegular.copyWith(
                                  color: ColorResources.white,
                                  fontSize: Dimensions.fontSizeDefault,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: pageIndicators(context,
                                      currentIndex: i,
                                      onBoardingList: onboarding),
                                ),
                                CustomButton(
                                  onTap: onboarding[i]["id"] == 3
                                      ? () {
                                          context
                                              .read<SplashProvider>()
                                              .dispatchOnboarding(true);
                                          NS.pushReplacement(
                                              context, const HomeScreen());
                                        }
                                      : () {
                                          pageC.animateToPage(
                                            (i + 1),
                                            duration: const Duration(
                                                milliseconds: 300),
                                            curve: Curves.easeInOut,
                                          );
                                        },
                                  btnColor:
                                      ColorResources.white.withOpacity(0.2),
                                  isBoxShadow: true,
                                  customText: true,
                                  isBorderRadius: true,
                                  sizeBorderRadius: 30.0,
                                  text: Text(
                                    onboarding[i]["id"] == 1
                                        ? 'MULAI'
                                        : 'LANJUT',
                                    style: poppinsRegular.copyWith(
                                      color: ColorResources.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: Dimensions.fontSizeOverLarge,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                });
          },
        )),
      ),
    );
  }

  List<Container> pageIndicators(
    BuildContext context, {
    required int currentIndex,
    required List onBoardingList,
  }) {
    List<Container> indicators = [];
    for (int i = 0; i < onBoardingList.length; i++) {
      indicators.add(
        Container(
          width: 10.0,
          height: 10.0,
          margin: const EdgeInsets.only(right: 10.0),
          decoration: BoxDecoration(
            color: i == currentIndex
                ? ColorResources.greyBottomNavbar
                : ColorResources.greyBottomNavbar.withOpacity(0.7),
            borderRadius: i == currentIndex
                ? BorderRadius.circular(50.0)
                : BorderRadius.circular(25.0),
          ),
        ),
      );
    }
    return indicators;
  }
}
