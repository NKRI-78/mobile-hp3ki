import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:hp3ki/data/models/feed/feedmedia.dart';
import 'package:readmore/readmore.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hp3ki/localization/language_constraints.dart';
import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/utils/dimensions.dart';

class PostVideo extends StatefulWidget {
  final FeedMedia media;
  final String caption;

  const PostVideo({
    Key? key,
    required this.media,
    required this.caption,
  }) : super(key: key);

  @override
  _PostVideoState createState() => _PostVideoState();
}

class _PostVideoState extends State<PostVideo> {
  VideoPlayerController? videoPlayerC;
  ChewieController? chewieC;

  Future<void> getData() async {
    videoPlayerC =
        VideoPlayerController.networkUrl(Uri.parse(widget.media.path ?? "-"))
          ..setLooping(false)
          ..initialize().then((_) {
            setState(() {});
          });
    chewieC = ChewieController(
      videoPlayerController: videoPlayerC!,
      aspectRatio: videoPlayerC!.value.aspectRatio,
      autoPlay: false,
      looping: false,
    );
  }

  @override
  void initState() {
    super.initState();

    getData();
  }

  @override
  void dispose() {
    videoPlayerC?.dispose();
    chewieC?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildUI();
  }

  Widget buildUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.all(Dimensions.marginSizeDefault),
          child: ReadMoreText(
            widget.caption,
            style: poppinsRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault,
            ),
            trimLines: 2,
            colorClickableText: ColorResources.black,
            trimMode: TrimMode.Line,
            trimCollapsedText: getTranslated("READ_MORE", context),
            trimExpandedText: '\n${getTranslated("LESS_MORE", context)}',
            moreStyle: poppinsRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                fontWeight: FontWeight.w600),
            lessStyle: poppinsRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                fontWeight: FontWeight.w600),
          ),
        ),
        videoPlayerC != null
            ? Container(
                margin: const EdgeInsets.only(top: 30.0, bottom: 30.0),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    AspectRatio(
                        aspectRatio: 1.0,
                        child: Chewie(
                          controller: chewieC!,
                        )),
                    // Positioned.fill(
                    //   child: GestureDetector(
                    //     behavior: HitTestBehavior.opaque,
                    //     onTap: () => videoPlayerC!.value.isPlaying
                    //     ? videoPlayerC!.pause()
                    //     : videoPlayerC!.play(),
                    //     child: Stack(
                    //       clipBehavior: Clip.none,
                    //       children: [
                    //         videoPlayerC!.value.isPlaying
                    //         ? Container()
                    //         : Container(
                    //             alignment: Alignment.center,
                    //             child: const Icon(
                    //               Icons.play_arrow,
                    //               color: ColorResources.white,
                    //               size: 80.0
                    //             ),
                    //           ),
                    //         Positioned(
                    //           bottom: 0.0,
                    //           left: 0.0,
                    //           right: 0.0,
                    //           child: VideoProgressIndicator(
                    //             videoPlayerC!,
                    //             allowScrubbing: true,
                    //           )
                    //         ),
                    //       ],
                    //     ),
                    //   )
                    // )
                  ],
                ),
              )
            : const SizedBox(
                height: 200,
                child: SpinKitThreeBounce(
                  size: 20.0,
                  color: ColorResources.primary,
                ),
              )
      ],
    );
  }
}
