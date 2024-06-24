import 'dart:io';

import 'package:flutter/material.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:hp3ki/providers/profile/profile.dart';
import 'package:hp3ki/views/basewidgets/appbar/custom.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:hp3ki/services/navigation.dart';
import 'package:hp3ki/providers/sos/sos.dart';
import 'package:hp3ki/views/basewidgets/snackbar/snackbar.dart';
import 'package:hp3ki/views/basewidgets/button/custom.dart';
import 'package:hp3ki/localization/language_constraints.dart';
import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/utils/dimensions.dart';

class SosDetailScreen extends StatefulWidget {
  final String label;
  final String content;
  final String message;

  const SosDetailScreen({
    Key? key, 
    required this.label,
    required this.content,
    required this.message
  }) : super(key: key);

  @override
  State<SosDetailScreen> createState() => _SosDetailScreenState();
}

class _SosDetailScreenState extends State<SosDetailScreen> {

  late Location location;

  @override
  void initState() {
    super.initState();

    location = Location();
  }

  @override  
  void dispose() {
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildUI();
  }

  Widget buildUI() {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBodyContent(),
    );
  }

  AppBar buildAppBar() {
    return const CustomAppBar(title: 'SOS').buildAppBar(context);
  }

  Stack buildBodyContent() {
    return Stack(
      clipBehavior: Clip.none,
      children: [

        Container(
          margin: const EdgeInsets.only(top: 130.0),
          alignment: Alignment.center,
          child: ListView(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            padding: EdgeInsets.zero,
            children: [
              
              Container(
                margin: const EdgeInsets.only(
                  top: 12.0, 
                  bottom: 12.0
                ),
                width: 150.0,
                height: 150.0,
                child: Image.asset('assets/images/sos/sos.png'),
              ),

              Container(
                margin: const EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0),
                child: Text(widget.content,
                  softWrap: false,
                  textAlign: TextAlign.center,
                  style: poppinsRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    fontWeight: FontWeight.w600
                  ),
                ),
              ),
              
              Container(
                margin:const EdgeInsets.only(top: 30.0, left: 16.0, right: 16.0),
                child: ConfirmationSlider(
                  foregroundColor: ColorResources.primary,
                  text: getTranslated("SLIDE_TO_CONFIRM", context),
                  onConfirmation: () async {
                    bool isActive = await location.serviceEnabled();
                    if(!isActive) {
                      if(Platform.isAndroid) {
                        AndroidIntent intent = const AndroidIntent(
                          action: 'android.settings.LOCATION_SOURCE_SETTINGS'
                        );
                        intent.launch();
                      } else {
                        ShowSnackbar.snackbar(context, getTranslated("PLEASE_ACTIVATE_LOCATION", context), "", ColorResources.error);
                        return;
                      }
                    } else {
                      buildAgreementDialog();
                    }
                  },
                ),
              )
            ] 
          ),  
        )
      ],
    );
  }

  Future<Object?> buildAgreementDialog() {
    return showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 700),
      pageBuilder: (BuildContext context, Animation<double> double, _) {
        return Center(
          child: Material(
            color: ColorResources.transparent,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              height: 280,
              decoration: BoxDecoration(
                color: ColorResources.white, 
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: const EdgeInsets.only(top: 10.0),
                      child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                        child: Image.asset("assets/images/icons/ic-alert.png",
                          width: 60.0,
                          height: 60.0,
                        )
                      ),
                    )
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      margin: const EdgeInsets.only(top: 0.0, left: 0.0),
                      child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                        child: Image.asset("assets/images/background/shading-top-left.png")
                      )
                    )
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      margin: const EdgeInsets.only(top: 0.0, right: 0.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Image.asset("assets/images/background/shading-right.png")
                      )
                    )
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      margin: const EdgeInsets.only(top: 200.0, right: 0.0),
                      child: Image.asset("assets/images/background/shading-right-bottom.png")
                    )
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: const EdgeInsets.only(top: 80.0),
                      child: Text(getTranslated("AGREEMENT_SOS", context),
                        style: poppinsRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          fontWeight: FontWeight.w600,
                          color: ColorResources.black
                        ),
                      )
                    )
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: const EdgeInsets.only(top: 20.0),
                      child: Text(getTranslated("INFO_SOS", context),
                        textAlign: TextAlign.center,
                        style: poppinsRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          fontWeight: FontWeight.w300,
                          color: ColorResources.black
                        ),
                      )
                    )
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 30.0),
                          child: Builder(
                            builder: (BuildContext context) {
                              return Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(child: Container()),
                                  Expanded(
                                    flex: 5,
                                    child: CustomButton(
                                      isBorderRadius: true,
                                      btnColor: ColorResources.white,
                                      btnTextColor: ColorResources.primary,
                                      onTap: () {
                                        NS.pop(context);
                                      }, 
                                      btnTxt: getTranslated("CANCEL", context)
                                    ),
                                  ),
                                  Expanded(child: Container()),
                                  Expanded(
                                    flex: 5,
                                    child: CustomButton(
                                      isBorderRadius: true,
                                      btnColor: ColorResources.primary,
                                      btnTextColor: ColorResources.white,
                                      isLoading: context.watch<SosProvider>().sosStatus == SosStatus.loading ? true : false,
                                      onTap: () async {
                                        await context.read<SosProvider>().sendSos(
                                          context, 
                                          type: widget.label,
                                          message: "${context.read<ProfileProvider>().user!.fullname} ${widget.message}"
                                        );
                                      }, 
                                      btnTxt: "OK"
                                    ),
                                  ),
                                  Expanded(child: Container()),
                                ],
                              );
                            },
                          )
                        )
                      ],
                    ) 
                  )
                ],
              ),
            ),
          )
        );
      },
      transitionBuilder: (_, anim, __, child) {
        Tween<Offset> tween;
        if (anim.status == AnimationStatus.reverse) {
          tween = Tween(begin: const Offset(-1, 0), end: Offset.zero);
        } else {
          tween = Tween(begin: const Offset(1, 0), end: Offset.zero);
        }
        return SlideTransition(
          position: tween.animate(anim),
          child: FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      },
    );
  }
}