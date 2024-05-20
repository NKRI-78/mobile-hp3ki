import 'dart:io';
import 'dart:typed_data';

import 'package:video_compress/video_compress.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

import 'package:hp3ki/services/navigation.dart';
import 'package:hp3ki/services/video.dart';

import 'package:hp3ki/localization/language_constraints.dart';

import 'package:hp3ki/utils/dimensions.dart';
import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/custom_themes.dart';

import 'package:hp3ki/providers/feed/feed.dart';

import 'package:hp3ki/views/basewidgets/snackbar/snackbar.dart';
import 'package:hp3ki/views/basewidgets/loader/circular.dart';

class CreatePostVideoScreen extends StatefulWidget {
  final Uint8List? thumbnail;
  final File? file;
  final String? groupId;
  final double? videoSize;
  const CreatePostVideoScreen(
      {Key? key, this.thumbnail, this.file, this.groupId, this.videoSize})
      : super(key: key);
  @override
  _CreatePostVideoScreenState createState() => _CreatePostVideoScreenState();
}

class _CreatePostVideoScreenState extends State<CreatePostVideoScreen> {
  late VideoPlayerController videoPlayerC;
  late TextEditingController captionC;

  late Subscription subscription;

  File? fileX;
  MediaInfo? mediaInfo;
  double? progress;

  @override
  void initState() {
    super.initState();
    captionC = TextEditingController();

    fileX = File(widget.file!.path);

    subscription = VideoCompress.compressProgress$.subscribe((event) {
      setState(() {
        progress = event;
      });
    });
    videoPlayerC = VideoPlayerController.file(fileX!);
  }

  @override
  void dispose() {
    VideoCompress.dispose();

    captionC.dispose();
    videoPlayerC.dispose();
    subscription.unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildUI();
  }

  Widget buildUI() {
    return Scaffold(
      body: CustomScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          slivers: [buildAppBar(), buildBodyContent()]),
    );
  }

  SliverAppBar buildAppBar() {
    return SliverAppBar(
      centerTitle: false,
      floating: true,
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
                          context
                              .read<FeedProvider>()
                              .setStateWritePost(WritePostStatus.loading);

                          MediaInfo? info =
                              await VideoServices.compressVideo(fileX!);
                          setState(() {
                            mediaInfo = info;
                          });

                          File f = File(mediaInfo!.path!);

                          context
                              .read<FeedProvider>()
                              .sendPostVideo(context, caption, f);
                          context
                              .read<FeedProvider>()
                              .setStateWritePost(WritePostStatus.loaded);
                          subscription.unsubscribe();
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
                                color: ColorResources.white,
                                fontSize: Dimensions.fontSizeDefault),
                          ),
                  ),
                )
              ]),
        )
      ],
    );
  }

  SliverToBoxAdapter buildBodyContent() {
    return SliverToBoxAdapter(
        child: Container(
      margin: const EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
            margin: const EdgeInsets.only(
                top: Dimensions.marginSizeDefault,
                bottom: Dimensions.marginSizeDefault),
            height: 185.0,
            child: displaySingleVideo()),
        TextField(
          maxLines: 3,
          controller: captionC,
          style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
          decoration: InputDecoration(
            labelText: "Caption",
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
      ]),
    ));
  }

  Widget displaySingleVideo() {
    int progressBar = progress == null ? 0 : (progress!).toInt();
    return widget.thumbnail == null && widget.videoSize == null
        ? const CircularProgressIndicator()
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.memory(widget.thumbnail!, height: 100.0),
              const SizedBox(height: 10.0),
              Text(
                "${getTranslated("FILE_SIZE", context)}: ${widget.videoSize.toString()} KB",
                style: poppinsRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault),
              ),
              const SizedBox(height: 10.0),
              Text(
                progressBar.toString() == "0"
                    ? ""
                    : "${progressBar.toString()} %",
                style: poppinsRegular.copyWith(
                  color: ColorResources.success,
                  fontSize: Dimensions.fontSizeDefault,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          );
  }
}
