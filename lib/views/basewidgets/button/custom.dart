import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

import 'package:hp3ki/utils/box_shadow.dart';
import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/utils/dimensions.dart';

import 'package:hp3ki/views/basewidgets/button/bounce.dart';

class CustomButton extends StatelessWidget {
  final Function() onTap;
  final String? btnTxt;
  final bool customText;
  final Widget? text;
  final double width;
  final double height;
  final double sizeBorderRadius;
  final Color loadingColor;
  final Color btnColor;
  final Color btnTextColor;
  final Color btnBorderColor;
  final bool isBorder;
  final bool isBorderRadius;
  final bool isLoading;
  final bool isBoxShadow;
  final bool isBackgroundImage;
  final bool isPrefixIcon;

  const CustomButton({
    Key? key, 
    required this.onTap, 
    this.btnTxt, 
    this.customText = false,
    this.text,
    this.width = double.infinity,
    this.height = 45.0,
    this.sizeBorderRadius = 10.0,
    this.isLoading = false,
    this.loadingColor = ColorResources.white,
    this.btnColor = ColorResources.primary,
    this.btnTextColor = ColorResources.white,
    this.btnBorderColor = Colors.transparent,
    this.isBorder = false,
    this.isBorderRadius = false,
    this.isBoxShadow = false,
    this.isBackgroundImage = false,
    this.isPrefixIcon = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Bouncing(
      onPress: isLoading ? null : onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          image: isBackgroundImage
            ? const DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  'assets/images/background/bg.png',
                )
              )
            : null,
          boxShadow: isBoxShadow 
          ? boxShadow 
          : [],
          color: btnColor,
          border: Border.all(
            color: isBorder 
            ? btnBorderColor 
            : Colors.transparent,
          ),
          borderRadius: isBorderRadius 
          ? BorderRadius.circular(sizeBorderRadius)
          : null
        ),
        child: isLoading 
        ? Center(
            child: SpinKitFadingCircle(
              color: loadingColor,
              size: 25.0
            ),
          )
        : Row(
          mainAxisAlignment: isPrefixIcon ? MainAxisAlignment.start : MainAxisAlignment.center,
          children: [
            isPrefixIcon ? const SizedBox(width: 15,) : Container(),
            isPrefixIcon
              ? Image.asset('assets/images/logo/logo.png',
                height: 48.0,
                width: 48.0,
              )
              : Container(),
            isPrefixIcon ? const SizedBox(width: 15,) : Container(),
            customText
              ? text! 
              : Center(
                child: Text(btnTxt!,
                  style: poppinsRegular.copyWith(
                    color: btnTextColor,
                    fontWeight: FontWeight.w600,
                    fontSize: Dimensions.fontSizeDefault,
                  ) 
                ),
              ),
          ],
        )
      ),
    );
  }
}
