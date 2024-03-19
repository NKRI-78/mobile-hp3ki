import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hp3ki/services/navigation.dart';
import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/utils/dimensions.dart';

class CustomAppBar {
  final String title;
  final bool? fromHome;
  final bool? isWebview;
  final List<Widget>? actions;
  final PreferredSize? bottom;
  final Function? onTapBack;

  const CustomAppBar(
      {Key? key,
      required this.title,
      this.actions,
      this.bottom,
      this.fromHome,
      this.isWebview,
      this.onTapBack});

  SliverAppBar buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      backgroundColor: ColorResources.bgGrey,
      centerTitle: true,
      toolbarHeight: 80.0,
      title: Text(
        title,
        style: poppinsRegular.copyWith(
          color: ColorResources.black,
          fontSize: Dimensions.fontSizeExtraLarge,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: actions,
      leading: fromHome == true
          ? Container()
          : Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: ColorResources.transparent, width: 1.0)),
              child: Padding(
                padding:
                    const EdgeInsets.only(left: Dimensions.paddingSizeLarge),
                child: IconButton(
                    onPressed: () {
                      onTapBack?.call();
                      NS.pop(context);
                    },
                    icon: Icon(
                      isWebview == true ? Icons.close : Icons.arrow_back,
                      size: Dimensions.iconSizeLarge,
                      color: ColorResources.black,
                    )),
              ),
            ),
      bottom: bottom,
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      elevation: 0.0,
      backgroundColor: ColorResources.bgGrey,
      centerTitle: true,
      toolbarHeight: 80.0,
      title: Text(
        title,
        style: poppinsRegular.copyWith(
          color: ColorResources.black,
          fontSize: Dimensions.fontSizeExtraLarge,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: actions,
      leading: fromHome == true
          ? Container()
          : Container(
              decoration: BoxDecoration(
                border:
                    Border.all(color: ColorResources.transparent, width: 1.0),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.only(left: Dimensions.paddingSizeLarge),
                child: IconButton(
                    onPressed: () {
                      onTapBack?.call();
                      NS.pop(context);
                    },
                    icon: Icon(
                      isWebview == true ? Icons.close : Icons.arrow_back,
                      size: Dimensions.iconSizeLarge,
                      color: ColorResources.black,
                    )),
              ),
            ),
      bottom: bottom,
    );
  }
}
