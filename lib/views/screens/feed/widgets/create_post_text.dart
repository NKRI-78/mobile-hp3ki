import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:hp3ki/services/navigation.dart';

import 'package:hp3ki/localization/language_constraints.dart';
import 'package:hp3ki/providers/feed/feed.dart';

import 'package:hp3ki/utils/dimensions.dart';
import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/custom_themes.dart';

import 'package:hp3ki/views/basewidgets/snackbar/snackbar.dart';
import 'package:hp3ki/views/basewidgets/loader/circular.dart';

class CreatePostText extends StatefulWidget {
  const CreatePostText({
    Key? key,
  }) : super(key: key);

  @override
  _CreatePostTextState createState() => _CreatePostTextState();
}

class _CreatePostTextState extends State<CreatePostText> {
  late ScrollController scrollC;
  late TextEditingController captionC;

  Future<bool> willPopScope() {
    NS.pop(context);
    return Future.value(true);
  }

  @override
  void initState() {
    super.initState();
    scrollC = ScrollController();
    captionC = TextEditingController();
  }

  @override
  void dispose() {
    scrollC.dispose();
    captionC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildUI();
  }

  Widget buildUI() {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: willPopScope,
      child: Scaffold(body: SafeArea(child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return NestedScrollView(
            controller: scrollC,
            headerSliverBuilder: (BuildContext context, bool inner) {
              return [buildAppBar(context)];
            },
            body: buildBodyContent(context),
          );
        },
      ))),
    );
  }

  SliverAppBar buildAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: ColorResources.white,
      title: Text(
        getTranslated("CREATE_POST", context),
        style: poppinsRegular.copyWith(
            color: ColorResources.black,
            fontSize: Dimensions.fontSizeLarge,
            fontWeight: FontWeight.bold),
      ),
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: ColorResources.black,
          size: Dimensions.iconSizeExtraLarge,
        ),
        onPressed: context.watch<FeedProvider>().writePostStatus ==
                WritePostStatus.loading
            ? () {}
            : () => Navigator.of(context).pop(),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: context.watch<FeedProvider>().writePostStatus ==
                          WritePostStatus.loading
                      ? () {}
                      : () async {
                          String caption = captionC.text.trim();
                          if (caption.isEmpty) {
                            ShowSnackbar.snackbar(
                                context,
                                'Caption harus diisi',
                                "",
                                ColorResources.error);
                            return;
                          }
                          if (caption.isNotEmpty) {
                            if (caption.length < 10) {
                              ShowSnackbar.snackbar(
                                  context,
                                  getTranslated("CAPTION_MINIMUM", context),
                                  "",
                                  ColorResources.error);
                              return;
                            }
                          }
                          if (caption.length > 1000) {
                            ShowSnackbar.snackbar(
                                context,
                                getTranslated("CAPTION_MAXIMAL", context),
                                "",
                                ColorResources.error);
                            return;
                          }
                          await context
                              .read<FeedProvider>()
                              .sendPostText(context, caption);
                          NS.pop(context);
                        },
                  child: Container(
                    width: context.watch<FeedProvider>().writePostStatus ==
                            WritePostStatus.loading
                        ? null
                        : 80.0,
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        color: ColorResources.primary,
                        borderRadius: BorderRadius.circular(20.0)),
                    child: context.watch<FeedProvider>().writePostStatus ==
                            WritePostStatus.loading
                        ? const Loader(
                            color: ColorResources.white,
                          )
                        : Text(
                            'Post',
                            textAlign: TextAlign.center,
                            style: poppinsRegular.copyWith(
                                color: ColorResources.white),
                          ),
                  ),
                )
              ]),
        )
      ],
      centerTitle: false,
    );
  }

  Container buildBodyContent(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0),
      child: TextField(
        maxLines: 3,
        controller: captionC,
        style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
        decoration: InputDecoration(
          labelText: getTranslated("WRITE_POST", context),
          labelStyle: poppinsRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault, color: Colors.grey),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.0),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.0),
          ),
        ),
      ),
    );
  }
}
