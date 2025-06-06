import 'package:flutter/material.dart';

import 'package:flutter_chat_types/flutter_chat_types.dart' show PreviewData;
import 'package:flutter_link_previewer/flutter_link_previewer.dart';

import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/utils/dimensions.dart';

class PostLink extends StatefulWidget {
  final String url;

  const PostLink({
    Key? key, 
    required this.url,
  }) : super(key: key);

  @override
  State<PostLink> createState() => PostLinkState();
}

class PostLinkState extends State<PostLink> {
  Map<String, PreviewData> previewData = {};

  @override
  Widget build(BuildContext context) {
    
    List<String?> urls =  [
      widget.url
    ];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 12.0),
        Container(
          margin: const EdgeInsets.only(
            left: Dimensions.marginSizeDefault, 
            right: Dimensions.marginSizeDefault
          ),
          child: LinkPreview(
            linkStyle: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall
            ),
            textStyle: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall
            ),
            padding: EdgeInsets.zero,
            enableAnimation: true,
            onPreviewDataFetched: (data) {
              setState(() {
                previewData = {
                  ...previewData,
                  urls[0]!: data,
                };
              });
            },
            previewData: previewData[urls[0]],
            text: urls[0]!,
            width: MediaQuery.of(context).size.width,
          ),
        )

      ],
    );
  } 
  
  
}