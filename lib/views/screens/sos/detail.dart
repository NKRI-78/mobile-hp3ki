import 'package:flutter/material.dart';
import 'package:hp3ki/providers/location/location.dart';

import 'package:hp3ki/providers/profile/profile.dart';
import 'package:hp3ki/services/navigation.dart';
import 'package:hp3ki/views/basewidgets/appbar/custom.dart';
import 'package:provider/provider.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

import 'package:hp3ki/providers/sos/sos.dart';
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
  State<SosDetailScreen> createState() => SosDetailScreenState();
}

class SosDetailScreenState extends State<SosDetailScreen> {

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
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              
              Container(
                margin:const EdgeInsets.only(top: 30.0, left: 16.0, right: 16.0),
                child: ConfirmationSlider(
                  foregroundColor: ColorResources.primary,
                  text: getTranslated("SLIDE_TO_CONFIRM", context),
                  onConfirmation: () async {
                    buildAgreementDialog();
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
                          fontWeight: FontWeight.bold,
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
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const Expanded(child: SizedBox()),
                              Expanded(
                                flex: 5,
                                child: CustomButton(
                                  isBorderRadius: true,
                                  btnColor: ColorResources.white,
                                  btnTextColor: ColorResources.primary,
                                  onTap: () {
                                    NS.pop();
                                  }, 
                                  btnTxt: getTranslated("CANCEL", context)
                                ),
                              ),
                              const Expanded(child: SizedBox()),
                              Expanded(
                                flex: 5,
                                child: CustomButton(
                                  isBorderRadius: true,
                                  btnColor: ColorResources.primary,
                                  btnTextColor: ColorResources.white,
                                  isLoading: context.watch<SosProvider>().sosStatus == SosStatus.loading ? true : false,
                                  onTap: () async {
                                    
                                    String? fullname = context.read<ProfileProvider>().user!.fullname;
                                    String? location = context.read<LocationProvider>().getCurrentNameAddress;

                                    String label = widget.label;
                                    String need = label == "Kecelakaan" 
                                    ? "membutuhkan" 
                                    : label == "Pencurian" 
                                    ? "mengalami"
                                    : label == "Kebakaran" 
                                    ? "mengalami"
                                    : label == "Bencana Alam" 
                                    ? "mengalami"
                                    : label == "Perampokan" 
                                    ? "mengalami" 
                                    : label == "Kerusuhan" 
                                    ? "mengalami" 
                                    : label;

                                    await context.read<SosProvider>().sendSos(
                                      context, 
                                      type: label,
                                      message: "$fullname ${widget.message}, $fullname $need ${widget.label}, di $location"
                                    );
                                  }, 
                                  btnTxt: "OK"
                                ),
                              ),
                              const Expanded(child: SizedBox()),
                            ],
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