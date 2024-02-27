import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hp3ki/views/basewidgets/snackbar/snackbar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hp3ki/localization/language_constraints.dart';

import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/utils/dimensions.dart';

import 'package:hp3ki/views/basewidgets/button/custom.dart';

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({super.key});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildUI();
  }

  Future<void> update(BuildContext context) async {
    final url = Platform.isAndroid
        ? "market://details?id=com.inovatif78.hp3ki"
        : "https://apps.apple.com/id/app/hp3ki/id1639982534";
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ShowSnackbar.snackbar(context, 'Ada kesalahan dengan update aplikasi', '',
          ColorResources.error);
    }
  }

  Widget buildUI() {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
          backgroundColor: ColorResources.white,
          body: SafeArea(child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints boxConstraints) {
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/avatar/avatar-update.png",
                          width: 250.0,
                          height: 250.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child:
                              Column(mainAxisSize: MainAxisSize.min, children: [
                            Text(
                              getTranslated('NEW_VERSION', context),
                              style: poppinsRegular.copyWith(
                                  fontSize: Dimensions.fontSizeLarge,
                                  fontWeight: FontWeight.w600,
                                  color: ColorResources.black),
                            ),
                            const SizedBox(height: 10.0),
                            if (Platform.isAndroid)
                              Text(
                                getTranslated('NEW_VERSION_ANDROID', context),
                                style: poppinsRegular.copyWith(
                                    fontSize: Dimensions.fontSizeDefault,
                                    color: ColorResources.black),
                                textAlign: TextAlign.center,
                              ),
                            if (Platform.isIOS)
                              Text(
                                getTranslated('NEW_VERSION_IOS', context),
                                style: poppinsRegular.copyWith(
                                    fontSize: Dimensions.fontSizeDefault,
                                    color: ColorResources.black),
                                textAlign: TextAlign.center,
                              ),
                          ]),
                        ),
                      ],
                    ),
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        color: ColorResources.primary,
                        width: double.infinity,
                        child: CustomButton(
                          onTap: () {
                            update(context);
                          },
                          height: 65,
                          isBorderRadius: false,
                          isBorder: false,
                          isBoxShadow: false,
                          btnColor: ColorResources.primary,
                          customText: true,
                          text: Text(
                            "UPDATE",
                            style: poppinsRegular.copyWith(
                                fontSize: Dimensions.fontSizeLarge,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.5,
                                color: ColorResources.white),
                          ),
                        ),
                      ))
                ],
              );
            },
          ))),
    );
  }
}
