import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';

import 'package:hp3ki/localization/language_constraints.dart';

import 'package:hp3ki/services/navigation.dart';

import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/utils/dimensions.dart';

import 'package:hp3ki/views/basewidgets/loader/circular.dart';
import 'package:hp3ki/views/basewidgets/snackbar/snackbar.dart';

import 'package:hp3ki/providers/feed/feed.dart';

class CreatePostLink extends StatefulWidget {
  const CreatePostLink({
    Key? key, 
  }) : super(key: key);

  @override
  _CreatePostLinkState createState() => _CreatePostLinkState();
}

class _CreatePostLinkState extends State<CreatePostLink> {
 
  late ScrollController scrollC;
  late TextEditingController captionC;
  late TextEditingController urlC;

  @override 
  void initState() {
    super.initState();
    scrollC = ScrollController();
    captionC = TextEditingController();
    urlC = TextEditingController();
  }

  @override 
  void dispose() {
    scrollC.dispose();
    captionC.dispose();
    urlC.dispose();
    super.dispose();
  }
    
  @override
  Widget build(BuildContext context) {
    return buildUI(); 
  }

  Widget buildUI() {
    return Builder(
      builder: (BuildContext context) {
        return Scaffold(
          
          body: NestedScrollView(
            controller: scrollC,
            headerSliverBuilder: (BuildContext context, bool inner) {
              return [
                buildAppBar(context)
              ];
            },  
            body: buildBodyContent(),
          )
        );
      },
    );
  }

  SliverAppBar buildAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: ColorResources.white,
      title: Text('Share Media', 
        style: poppinsRegular.copyWith(
          color: ColorResources.black,
          fontSize: Dimensions.fontSizeLarge,
          fontWeight: FontWeight.bold
        ),
      ),
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: ColorResources.black,
          size: Dimensions.iconSizeExtraLarge,
        ),
        onPressed: context.watch<FeedProvider>().writePostStatus == WritePostStatus.loading 
        ? () {} 
        : () {
          NS.pop(context);
        },
      ),
      actions: [
        Container(
          margin: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: context.watch<FeedProvider>().writePostStatus == WritePostStatus.loading 
                ? () {} 
                : () async {
                  String caption = captionC.text.trim();
                  String url = urlC.text.trim();
                  if(caption.isEmpty) {
                    ShowSnackbar.snackbar(context, 'Caption harus diisi', "", ColorResources.error);
                    return;
                  }
                  if(caption.isNotEmpty) {
                    if(caption.length < 10) {
                      ShowSnackbar.snackbar(context, getTranslated("CAPTION_MINIMUM", context), "", ColorResources.error);
                      return;
                    }
                  } 
                  if(caption.length > 1000) {
                    ShowSnackbar.snackbar(context, getTranslated("CAPTION_MAXIMAL", context), "", ColorResources.error);
                    return;
                  }                  
                  if(url.isEmpty) {
                    ShowSnackbar.snackbar(context, getTranslated("URL_IS_REQUIRED", context), "", ColorResources.error);
                    return;
                  } 
                  final dio = Dio();
                  try {
                    Response res = await dio.getUri(Uri.parse(url));
                    if(res.statusCode == 200) {
                      await context.read<FeedProvider>().sendPostLink(context, caption, url);  
                      NS.pop(context);
                    } else {
                      ShowSnackbar.snackbar(context, 'Link tidak bisa diakses!', "", ColorResources.error);
                    }
                  } on DioError catch (_) {
                    ShowSnackbar.snackbar(context, 'Format link salah atau tidak bisa diakses!', "", ColorResources.error);
                  }
                },
                child: Container(
                  width: context.watch<FeedProvider>().writePostStatus == WritePostStatus.loading ? null : 80.0,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: ColorResources.primary,
                    borderRadius: BorderRadius.circular(20.0)
                  ),
                  child: context.watch<FeedProvider>().writePostStatus == WritePostStatus.loading 
                  ? const Loader(
                      color: ColorResources.white,
                    ) 
                  : Text('Post',
                    textAlign: TextAlign.center,
                    style: poppinsRegular.copyWith(
                      color: ColorResources.white
                    ),
                  ),
                ),
              )
            ]
          ),
        )
      ],
      centerTitle: false,
      floating: true, 
    );
  }

  Column buildBodyContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0),
          child: TextField(
            maxLines: 3,
            controller: captionC,
            style: poppinsRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault
            ),
            decoration: InputDecoration(
              labelText: "Caption",
              labelStyle: poppinsRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: Colors.grey
              ),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey, 
                  width: 1.0
                ),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 1.0
                ),
              )
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0),
          child: TextField(
            controller: urlC,
            style: poppinsRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault
            ),
            decoration: InputDecoration(
              labelText: "Link",
              hintText: 'Example: http://www.google.com',
              labelStyle: poppinsRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: Colors.grey
              ),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey, 
                  width: 1.0
                ),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey, 
                  width: 1.0
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

}


