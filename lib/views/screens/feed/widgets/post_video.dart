
<<<<<<< HEAD
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:visibility_detector/visibility_detector.dart';

import 'package:flutter/material.dart';

import 'package:hp3ki/utils/color_resources.dart';

import 'package:video_player/video_player.dart';

=======
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:hp3ki/utils/color_resources.dart';

>>>>>>> 3de3b56a677787d3a71350f1578c9cfdc07bb277
class PostVideo extends StatefulWidget {
  final String media;
  final bool isPlaying;
  final VoidCallback onPlay;
  final VoidCallback onPause;

  const PostVideo({
    super.key, 
    required this.media,
    required this.isPlaying,
    required this.onPlay,
    required this.onPause,
  });

  @override
<<<<<<< HEAD
  State<PostVideo> createState() => PostVideoState();
}

class PostVideoState extends State<PostVideo> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool isPlay = false;

  VideoPlayerController? videoC;

  @override
  void didUpdateWidget(PostVideo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.media != oldWidget.media) {
      reinitializePlayer();
    }

    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying) {
        videoC?.play();
=======
  PostVideoState createState() => PostVideoState();
}

class PostVideoState extends State<PostVideo> {

  VideoPlayerController? videoPlayerC;
  ChewieController? chewieC;
  
  Future<void> getData() async {
    if(!mounted) return;
     if(io.Platform.isAndroid) {
        videoPlayerC = VideoPlayerController.networkUrl(Uri.parse(widget.media))
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
>>>>>>> 3de3b56a677787d3a71350f1578c9cfdc07bb277
      } else {
        videoC?.pause();
      }
    
  }

  Future<void> reinitializePlayer() async {
    await videoC?.dispose();
    await initializePlayer();
  }

  Future<void> initializePlayer() async {
    try {
      videoC = VideoPlayerController.networkUrl(Uri.parse(widget.media))
      ..addListener(updateState);
      await videoC!.initialize();
    } catch (e) {
      debugPrint('Error initializing video player: $e');
    } finally {
      if (mounted) {
        setState(() {});
      }
    }
  }

    void updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  void onVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction == 0.0) {
      videoC?.pause();
    }
  }

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
    
    Future.microtask(() => initializePlayer());
=======
     
    Future.microtask(() => getData());
>>>>>>> 3de3b56a677787d3a71350f1578c9cfdc07bb277
  }

  @override
  void dispose() {
    videoC?.removeListener(updateState);
    videoC?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

<<<<<<< HEAD
    if (videoC == null || !videoC!.value.isInitialized) {
      return const SizedBox(
        height: 80.0,
        child: Center(
          child: SpinKitChasingDots(
            color: ColorResources.primaryOrange,
          ),
        ),
      );
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
    
        Container(
          margin: const EdgeInsets.only(
            top: 10.0,
            left: 12.0,
            right: 12.0,
          ),
          child: AspectRatio(
            aspectRatio: videoC!.value.aspectRatio,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: VideoPlayer(videoC!),
=======
  Widget buildUI() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            videoPlayerC != null
            ? Container(
                margin: const EdgeInsets.only(
                  top: 30.0,
                  bottom: 30.0
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    AspectRatio(
                      aspectRatio: chewieC!.aspectRatio!,
                      child: Chewie(
                        controller: chewieC!,
                      )
                    ),
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
>>>>>>> 3de3b56a677787d3a71350f1578c9cfdc07bb277
            ),
          ),
        ),
    
        Positioned.fill(
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: ColorResources.primaryOrange,
                borderRadius: BorderRadius.circular(10.0)
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(10.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: widget.isPlaying
                  ? const Icon(Icons.pause,
                      color: ColorResources.white,
                    )
                  : const Icon(Icons.play_arrow,
                      color: ColorResources.white,
                    )
                ),
                onTap: widget.isPlaying ? widget.onPause : widget.onPlay,
              ),
            )
          )
        ),
    
      ],
    );
  }
}