import 'package:flutter/material.dart';
import 'package:hp3ki/localization/language_constraints.dart';
import 'package:hp3ki/services/navigation.dart';
import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/utils/dimensions.dart';
import 'package:hp3ki/views/basewidgets/appbar/custom.dart';
import 'package:hp3ki/views/basewidgets/button/custom.dart';

class ComingSoonScreen extends StatefulWidget {
  final String? title;
  final bool isNavbarItem;
  final bool isMaintenance;
  
  const ComingSoonScreen({ 
    this.isMaintenance = false,
    this.isNavbarItem = false,
    required this.title,
    Key? key }) 
    : super(key: key);

  @override
  State<ComingSoonScreen> createState() => _ComingSoonScreenState();
}

class _ComingSoonScreenState extends State<ComingSoonScreen> {

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

  Widget buildUI() {
    return Scaffold(
      backgroundColor: ColorResources.greyLightPrimary,
      appBar: buildAppBar(context),
      body: buildBodyContent(),
    );
  }

  Widget buildBodyContent() {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorResources.greyLightPrimary,
        body: buildComingSoonSection(),
      )
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return CustomAppBar(title: widget.title ?? "Coming Soon", fromHome: widget.isNavbarItem).buildAppBar(context);
  }

  Center buildComingSoonSection() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 50.0),
              child: Image.asset("assets/images/avatar/avatar-comingsoon.png",
                height: 300,
                width: 300,
                fit: BoxFit.fitWidth,
              ),
            ),
            Text(widget.isMaintenance == true ? 'Maintenance' : 'Coming Soon',
              style: poppinsRegular.copyWith(
                color: ColorResources.black,
                fontWeight: FontWeight.w600,
                fontSize: Dimensions.fontSizeExtraLarge,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5,),
            Text(widget.isMaintenance == true 
              ? "Mohon maaf, sedang ada pemeliharaan sistem pada aplikasi untuk sementara waktu."
              : getTranslated('UNDER_DEVELOPMENT', context),
              style: poppinsRegular.copyWith(
                color: ColorResources.black.withOpacity(0.6),
                fontSize: Dimensions.fontSizeDefault,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25,),
            widget.isNavbarItem == true
            ? Container()
            : CustomButton(
                onTap: () {
                  NS.pop(context);
                }, 
                customText: true,
                text: Text(getTranslated('BACK', context),
                  style: poppinsRegular.copyWith(
                    fontSize: Dimensions.fontSizeLarge,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                    color: ColorResources.white
                  ),
                ),
                btnColor: ColorResources.primary,
                isBorderRadius: true,
                sizeBorderRadius: 10.0,
                isBoxShadow: true,
              ),
          ],
        ),
      ),
    );
  }
}