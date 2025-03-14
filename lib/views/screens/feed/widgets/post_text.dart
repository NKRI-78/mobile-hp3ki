import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

import 'package:hp3ki/localization/language_constraints.dart';

import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/utils/dimensions.dart';

class PostText extends StatefulWidget {
  final String text;

  const PostText(
    this.text, 
    {Key? key}
  ) : super(key: key);

  @override
  PostTextState createState() => PostTextState();
}

class PostTextState extends State<PostText> {

  @override
  Widget build(BuildContext context) {
    return buildUI();
  }
  
  Widget buildUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ReadMoreText(
          widget.text,
          style: robotoRegular.copyWith(
            fontSize: Dimensions.fontSizeDefault,
          ),
          trimLines: 3,
          colorClickableText: ColorResources.black,
          trimMode: TrimMode.Line,
          trimCollapsedText: getTranslated("READ_MORE", context),
          trimExpandedText: getTranslated("LESS_MORE", context),
          moreStyle: robotoRegular.copyWith(
            fontSize: Dimensions.fontSizeSmall, 
            fontWeight: FontWeight.bold
          ),
          lessStyle: robotoRegular.copyWith(
            fontSize: Dimensions.fontSizeSmall, 
            fontWeight: FontWeight.bold
          ),
        ),
      ],
    );
  }

}