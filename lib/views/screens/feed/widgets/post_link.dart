import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_chat_types/flutter_chat_types.dart' show PreviewData;
import 'package:flutter_link_previewer/flutter_link_previewer.dart';

import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/utils/dimensions.dart';

class PostLink extends StatefulWidget {
  final dynamic url;
  final String caption;

  const PostLink({
    Key? key, 
    required this.url,
    required this.caption
  }) : super(key: key);

  @override
  State<PostLink> createState() => _PostLinkState();
}

class _PostLinkState extends State<PostLink> {
  Map<String, PreviewData> datas = {};

  @override
  Widget build(BuildContext context) {
    return buildUI(); 
  } 
  
  Widget buildUI() {
    List<String?> urls =  [
      widget.url!
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [

        Container(
          margin: const EdgeInsets.only(left: Dimensions.marginSizeDefault),
          child: Text(widget.caption,
            style: poppinsRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault
            ),
          ),
        ),
        
        const SizedBox(height: 12.0),

        Container(
          margin: const EdgeInsets.only(
            left: Dimensions.marginSizeDefault, 
            right: Dimensions.marginSizeDefault
          ),
          child: LinkPreview(
            linkStyle: poppinsRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault
            ),
            textStyle: poppinsRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault
            ),
            onLinkPressed: (val) async {
              Uri url = Uri.parse(val);
              await launchUrl(url);
            },
            padding: EdgeInsets.zero,
            enableAnimation: true,
            onPreviewDataFetched: (data) {
              setState(() {
                datas = {
                  ...datas,
                  urls[0]!: data,
                };
              });
            },
            previewData: datas[urls[0]],
            text: urls[0]!,
            width: MediaQuery.sizeOf(context).width,
          ),
        )

      ],
    );
  }
  
}