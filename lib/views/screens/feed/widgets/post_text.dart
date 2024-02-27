import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

import 'package:hp3ki/localization/language_constraints.dart';

import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/utils/dimensions.dart';

class PostText extends StatefulWidget {
  final String item;

  const PostText(
    this.item, 
    {Key? key}
  ) : super(key: key);

  @override
  _PostTextState createState() => _PostTextState();
}

class _PostTextState extends State<PostText> {

  @override
  Widget build(BuildContext context) {
    return buildUI();
  }
  
  Widget buildUI() {
    return Builder(
      builder: (BuildContext context) {
        return Container(
          margin: const EdgeInsets.all(Dimensions.marginSizeDefault),
          child: ReadMoreText(
            widget.item,
            style: poppinsRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault,
            ),
            trimLines: 2,
            colorClickableText: ColorResources.black,
            trimMode: TrimMode.Line,
            trimCollapsedText: getTranslated("READ_MORE", context),
            trimExpandedText: '\n${'\n${getTranslated("LESS_MORE", context)}'}',
            moreStyle: poppinsRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault, 
              fontWeight: FontWeight.w600
            ),
            lessStyle: poppinsRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault, 
              fontWeight: FontWeight.w600
            ),
          ) 
        );
      },
    );
  }

}